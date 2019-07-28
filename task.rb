# frozen_string_literal: true

class Canvas
  def initialize(width, height)
    @width = width
    @height = height
    @canvas = create_canvas
  end

  def create_canvas
    canvas = []
    @height.times do |_h|
      canvas << Array.new(20, ' ')
    end
    canvas
  end

  def write_file(file_path)
    File.open(file_path, 'a') do |line|
      line.puts '-' * (@width + 2)
      line.puts @canvas.map { |line| '|' + line.join('') + '|' }
      line.puts '-' * (@width + 2)
      line.puts "\n"
    end
  end

  def line(x1, y1, x2, y2)
    x1 -= 1; x2 -= 1; y1 -= 1; y2 -= 1
    cur_x = x1
    cur_y = y1
    loop do
      @canvas[cur_y][cur_x] = 'x'
      break if cur_x == x2 && cur_y == y2

      if cur_x == x2
        cur_y > y2 ? cur_y -= 1 : cur_y += 1
      else
        cur_x > x2 ? cur_x -= 1 : cur_x += 1
      end
    end
  end

  def rectangle(x1, y1, x2, y2)
    line(x1, y1, x2, y1)
    line(x1, y1, x1, y2)
    line(x2, y2, x1, y2)
    line(x2, y2, x2, y1)
  end

  def cell_neighbours(x, y)
    neighbours = []
    possible_neighbours = [[x + 1, y], [x, y + 1], [x + 1, y + 1], [x - 1, y], [x, y - 1], [x - 1, y - 1], [x - 1, y + 1], [x + 1, y - 1]]

    possible_neighbours.each do |x, y|
      next if !@canvas[y] || !@canvas[y][x] || x < 0 || y < 0

      neighbours << [x, y]
    end

    neighbours
  end

  def bucket_fill(x, y, replace_color = 'z')
    # TODO: add user input checks
    x -= 1; y -= 1
    node_color = @canvas[y][x]
    return if node_color == replace_color
    queue = Queue.new
    @canvas[y][x] = replace_color
    queue.enq([x, y])
    until queue.empty?
      candidate_x, candidate_y = queue.deq
      cell_neighbours(candidate_x, candidate_y).each do |neighbour_x, neighbour_y|
        if node_color == @canvas[neighbour_y][neighbour_x]
          @canvas[neighbour_y][neighbour_x] = replace_color
          queue.enq([neighbour_x, neighbour_y])
        end
      end
    end
  end
end

class Executor
  def initialize
    @input = ARGV[0]
    @canvas_instance = nil
    @output = File.join(__dir__, 'output.txt')
  end

  def process_file
    File.open(@input).each do |line|
      case line
      when /^C\s(\d+)\s(\d+)$/
        @canvas_instance = Canvas.new(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i)
        @canvas_instance.write_file(@output)
      when /^L\s(\d+)\s(\d+)\s(\d+)\s(\d+)$/
        @canvas_instance.line(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i, Regexp.last_match(3).to_i, Regexp.last_match(4).to_i)
        @canvas_instance.write_file(@output)
      when /^R\s(\d+)\s(\d+)\s(\d+)\s(\d+)$/
        @canvas_instance.rectangle(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i, Regexp.last_match(3).to_i, Regexp.last_match(4).to_i)
        @canvas_instance.write_file(@output)
      when /^B\s(\d+)\s(\d+)\s(.)$/
        @canvas_instance.bucket_fill(Regexp.last_match(1).to_i, Regexp.last_match(2).to_i, Regexp.last_match(3).to_i)
        @canvas_instance.write_file(@output)
      else
        puts "Unrecognized command: #{line}"
      end
    end
  end
end

executor = Executor.new
executor.process_file
