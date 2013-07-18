require 'spec_helper'

describe Devan::Error do
  before do
    @error = Devan::Error.new('Unauthorized', 401)
  end

  it 'should have a message' do
    @error.message.should == 'Unauthorized'
  end

  it 'should have an error code' do
    @error.code.should == 401
  end
end
