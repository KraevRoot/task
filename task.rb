class Canvas
  def initialize(width, height)
    @width = width
    @height = height
    @canvas = create_canvas()
  end

  def create_canvas
    canvas = []
    @height.times { |h|
      canvas << Array.new(20, "@")
    }
    canvas
  end

  def to_s
    puts @canvas.map { |line| line.join("") }
  end

  def line(x1, y1, x2, y2)
    # if points the same
    # if direction positive
    # if direction negative
    # TODO decrease user input 1 = 0, 2 = 1
    cur_x = x1
    cur_y = y1
    loop do
      @canvas[cur_y][cur_x] = 'x'
      break if cur_x == x2 && cur_y == y2
      if cur_x == x2
        if cur_y > y2
          cur_y -= 1
        else
          cur_y += 1
        end
      else
        if cur_x > x2
          cur_x -= 1
        else
          cur_x += 1
        end
      end
    end
  end
end

c = Canvas.new(20, 4)
puts c

c.line(1, 2, 6, 2)

c.line(2,0, 2, 3)

puts c
