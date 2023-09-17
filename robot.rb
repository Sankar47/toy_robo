class Robot
    DIRECTIONS = %w(NORTH EAST SOUTH WEST).freeze
    DIRECTION_MAP = {
      "NORTH" => [0, 1],
      "SOUTH" => [0, -1],
      "EAST"  => [1, 0],
      "WEST"  => [-1, 0]
    }.freeze
    TABLE_SIZE = [5, 5].freeze

    def initialize
        @x_coordinate = nil
        @y_coordinate = nil
        @direction = nil
        @placed = false
        @space_flag = false
    end

    def run
        robot_command = ""

        #Accepting continuous commands
        loop do
            robot_command = gets.chomp
            return if game_over?(robot_command)
            robot_command_split = robot_command.split(' ', 2)
            @placed = true if robot_command_split[0] == "PLACE"

            if @placed
                if robot_command_split[0] == "PLACE" && robot_command_split[1]
                    place(robot_command_split[1].split(","))
                elsif ["MOVE", "LEFT", "RIGHT", "REPORT"].include?(robot_command)
                    send(robot_command.downcase)
                else
                    #ignore
                end
            end
        end
    end

    def place(arr)
        if valid_position?(arr[0].to_i, arr[1].to_i)
            @x_coordinate = arr[0].to_i
            @y_coordinate = arr[1].to_i
            @direction = arr[2].strip

            #Checking whether input has space before direction field
            if arr[2].strip != arr[2]
                @space_flag = true
            else
                @space_flag = false
            end
        end
    end

    def left
        @direction = get_direction(DIRECTIONS)
    end

    def right
        @direction = get_direction(DIRECTIONS.reverse)
    end

    def move
        if new_position = DIRECTION_MAP[@direction]
            new_x, new_y = @x_coordinate + new_position[0], @y_coordinate + new_position[1]
            if valid_position?(new_x, new_y)
                @x_coordinate, @y_coordinate = new_x, new_y
            end
        end
    end

    def report
        #Checking for valid PLACE command
        if @placed && (@x_coordinate && @y_coordinate) && valid_direction?(@direction)
            #Adding space before direction field based on input 
            if @space_flag
                puts "#{@x_coordinate},#{@y_coordinate}, #{@direction}"
            else
                puts "#{@x_coordinate},#{@y_coordinate},#{@direction}"
            end
        else
            puts "Inappropriate input"
        end
    end

    private

    def valid_position?(x=nil, y=nil)
        #return true if x and y are inside the table
        x >= 0 && x < TABLE_SIZE[0] && y >= 0 && y < TABLE_SIZE[1]
    end

    def valid_direction?(direction)
        direction && DIRECTIONS.include?(direction)
    end

    def get_direction(_directions)
      _directions[_directions.find_index(@direction) - 1]
    end

    def game_over?(command)
      command.empty?
    end
end