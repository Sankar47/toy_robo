require 'rspec'
require_relative '../robot'

RSpec.describe Robot do
  # Create a subject for testing
  subject(:robot) { Robot.new }

  describe "#place" do
    it "places the robot at the specified position and direction" do
      robot.place(["2", "3", "NORTH"])
      expect(robot.instance_variable_get(:@x_coordinate)).to eq(2)
      expect(robot.instance_variable_get(:@y_coordinate)).to eq(3)
      expect(robot.instance_variable_get(:@direction)).to eq("NORTH")
    end

    it "ignores invalid positions" do
      robot.place(["6", "5", "EAST"])
      expect(robot.instance_variable_get(:@x_coordinate)).to be_nil
      expect(robot.instance_variable_get(:@y_coordinate)).to be_nil
      expect(robot.instance_variable_get(:@direction)).to be_nil
    end
  end

  describe "#move" do
    it "move the Robot to one step in the same direction" do
      robot.place([1, 2, "NORTH"])
      robot.move
      expect(robot.instance_variable_get(:@direction)).to eq("NORTH")
      expect(robot.instance_variable_get(:@y_coordinate)).to eq(3)
    end

    it "Robot won't move when it exeeds table" do
      robot.place([4, 4, "NORTH"])
      robot.move
      expect(robot.instance_variable_get(:@direction)).to eq("NORTH")
      expect(robot.instance_variable_get(:@y_coordinate)).to eq(4)
    end
  end

  describe "#left" do
    it "changes the Robot's direction to the left" do
      robot.place([1, 2, "NORTH"])
      robot.left
      expect(robot.instance_variable_get(:@direction)).to eq("WEST")
    end
  end

  describe "#right" do
    it "changes the Robot's direction to the right" do
      robot.place([1, 2, "NORTH"])
      robot.right
      expect(robot.instance_variable_get(:@direction)).to eq("EAST")
    end
  end

  describe '#valid_position?' do
    it 'returns true for valid positions' do
      expect(robot.send(:valid_position?, 1, 2)).to be true
    end

    it 'returns false for positions outside the table' do
      expect(robot.send(:valid_position?, 6, 6)).to be false
    end
  end

  describe '#valid_direction?' do
    it 'returns true for valid directions' do
      expect(robot.send(:valid_direction?, 'NORTH')).to be true
    end

    it 'returns false for invalid directions' do
      expect(robot.send(:valid_direction?, 'INVALID')).to be false
    end
  end


  describe 'command simulation' do
    it 'simulates a sequence of commands and verifies the final state' do
      allow(robot).to receive(:gets).and_return(
        "PLACE 1,2,NORTH\n",  # Place the robot
        "MOVE\n",             # Move the robot
        "LEFT\n",             # Turn left
        "MOVE\n",             # Move again
        "REPORT\n",           # Report the position
        "\n"                 # Quit
      )

      robot.run  # Simulate the commands

      # Verify the final position reported
      expect { robot.report }.to output("0,3,WEST\n").to_stdout
    end

    it 'simulates a sequence of commands with space before direction and verifies the final state' do
        allow(robot).to receive(:gets).and_return(
          "PLACE 1,2, NORTH\n",  # Place the robot
          "MOVE\n",             # Move the robot
          "LEFT\n",             # Turn left
          "MOVE\n",             # Move again
          "REPORT\n",           # Report the position
          "\n"                 # Quit
        )
  
        robot.run  # Simulate the commands
  
        # Verify the final position reported
        expect { robot.report }.to output("0,3, WEST\n").to_stdout
    end
  end
end