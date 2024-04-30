function exit()
  __exit()
end

--- ITERATORS --- 
function all(t)
  local i = 0
  return function() i = i + 1; return t[i] end
end

function print_table(t)
  for k, v in pairs(t) do
    print(k, v)
  end
end

add = table.insert


--- MATH ---
cos = math.cos
sin = math.sin
atan2 = math.atan2
pi = math.pi


--- MISC ---
function sleep (a) 
  local sec = tonumber(os.clock() + a); 
  while (os.clock() < sec) do 
  end 
end
colors = {
  "#000000",
  "#1D2B53",
  "#7E2553",
  "#008751",
  "#AB5236",
  "#5F574F",
  "#C2C3C7",
  "#FFF1E8",
  "#FF004D",
  "#FFA300",
  "#FFEC27",
  "#00E436",
  "#29ADFF",
  "#83769C",
  "#FF77A8",
  "#FFCCAA"
}

--- I/O ---
function alert(msg)
  js.global:alert(msg)
end
function pset(x, y, c)
  js.global:render_call("pset", math.floor(x), math.floor(y), c)
end
function cls()
  js.global:render_call("cls")
end
function circ(x, y, r, c)
  js.global:render_call("circ_fast", math.floor(x), math.floor(y), r, c)
end
function circfill(x, y, r, c)
  js.global:render_call("circfill_fast", math.floor(x), math.floor(y), r, c)
end

--- PROGRAM ENTRY POINT ---
function start()
  if init then
    init()
  end
  if update then
    while true do
      update()
    end
  end
end