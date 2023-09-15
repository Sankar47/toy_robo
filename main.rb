
class Robot
    @@can_robot_start = false
    @@directions_arr = ["NORTH", "EAST", "SOUTH", "WEST"]

    def initialize
        @x_coordinate = nil
        @y_coordinate = nil
        @direction = nil
        @table_size = [5, 5]
    end

    def commands
        robot_command = ""

        #Accepting continuous commands
        while robot_command.downcase != "q"
            print "Enter a command (type 'q' to quit): "
            robot_command = gets.chomp
            robot_command_split = robot_command.split
            @@can_robot_start = true if robot_command_split[0] == "PLACE"

            if @@can_robot_start
                if robot_command_split[0] == "PLACE" && robot_command_split[1]
                    place(robot_command_split[1].split(","))
                elsif robot_command == "MOVE"
                    move()
                elsif robot_command == "LEFT"
                    left()
                elsif robot_command == "RIGHT"
                    right()
                elsif robot_command == "REPORT"
                    report()
                else
                    print "Invalid Command "
                end
            end
        end
    end

    def place(arr)
        if valid_position?(arr[0].to_i, arr[1].to_i)
            @x_coordinate = arr[0].to_i
            @y_coordinate = arr[1].to_i
            @direction = arr[2]
        end
    end

    def left
        @direction = get_direction(@@directions_arr)
    end

    def right
        @direction = get_direction(@@directions_arr.reverse)
    end

    def move
        direction_map = {
          "NORTH" => [0, 1],
          "SOUTH" => [0, -1],
          "EAST"  => [1, 0],
          "WEST"  => [-1, 0]
        }

        if new_position = direction_map[@direction]
            new_x, new_y = @x_coordinate + new_position[0], @y_coordinate + new_position[1]
            if valid_position?(new_x, new_y)
                @x_coordinate, @y_coordinate = new_x, new_y
            end
        end
    end

    def report
        #Checking for valid PLACE command
        if @@can_robot_start && (@x_coordinate && @y_coordinate) && valid_direction?(@direction)
            puts "#{@x_coordinate},#{@y_coordinate},#{@direction}"
        else
            puts "Inappropriate input"
        end
    end

    private

    def valid_position?(x=nil, y=nil)
        #return true if x and y are inside the table
        x >= 0 && x < @table_size[0] && y >= 0 && y < @table_size[1]
    end

    def valid_direction?(direction)
        direction && @@directions_arr.include?(direction)
    end

    def get_direction(arr)
        arr[arr.find_index(@direction) - 1]
    end
end


robot = Robot.new
robot.commands