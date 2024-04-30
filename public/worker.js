importScripts('fengari-web.js');

function formatError(error, offset) {
  return error.replace(/\[string "\?"\]:(\d+):/g, (_, line) => {
    if (line < offset) return `[lib.lua]:${line}:`;
    return `[main.lua]:${line - offset}:`
  });
}

onmessage = async e => {
  const res = await fetch('./lib.lua');
  const lib = await res.text();
  const offset = lib.split('\n').length;
  

  self.alert = function (msg) {
    postMessage({
      type: 'alert',
      payload: msg
    });
  }

  self.render_call = function(type, ...args) {
    postMessage({
      type: 'render_call',
      payload: { type, args }
    });
  }

  const code = e.data;
  let loaded;
  try {
    loaded = fengari.load(lib + '\n' + code + '\nstart()');
  } catch (error) {
    console.log('[worker] Error while loading code');
    postMessage({
      type: 'error_load',
      payload: formatError(error.message, offset)
    });
    return;
  }

  try {
    console.log('[worker] Running code...');
    const output = loaded();
    console.log('[worker] Code executed successfully');
    postMessage({
      type: 'output',
      payload: output
    }); 
  } catch (error) {

    if (error.includes('__exit')) {
      console.log('[worker] Code execution terminated by user');
      postMessage({
        type: 'exit'
      });
      return;
    }

    console.log('[worker] Error while running code');
    postMessage({
      type: 'error_runtime',
      payload: formatError(error, offset)
    });
  }
  
}