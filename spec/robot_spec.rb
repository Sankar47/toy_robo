require 'rspec'
require_relative '../robot'

RSpec.describe Robot do
  # Create a subject for testing
  subject(:robot) { described_class.new }

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
        'PLACE 1,2,NORTH',  # Place the robot
        'MOVE',             # Move the robot
        'LEFT',             # Turn left
        'MOVE',             # Move again
        'REPORT',           # Report the position
        'q'                 # Quit
      )

      robot.commands  # Simulate the commands

      # Verify the final position reported
      expect { robot.report }.to output("0,3,WEST\n").to_stdout
    end

    it 'simulates a sequence of commands with space before direction and verifies the final state' do
        allow(robot).to receive(:gets).and_return(
          'PLACE 1,2, NORTH',  # Place the robot
          'MOVE',             # Move the robot
          'LEFT',             # Turn left
          'MOVE',             # Move again
          'REPORT',           # Report the position
          'q'                 # Quit
        )
  
        robot.commands  # Simulate the commands
  
        # Verify the final position reported
        expect { robot.report }.to output("0,3, WEST\n").to_stdout
      end
  end
end