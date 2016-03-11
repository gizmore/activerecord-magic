require 'spec_helper'

describe ActiveRecord::Magic::Util do

  it "offers clamping" do
    expect(4.6.clamp(1,3)).to eq(3)
    expect("-4.6".clamp(1,3)).to eq(1)
  end

  it "offers trim" do
    expect('aabbaa'.trim('a')).to eq('bb')
    expect('aabbaa'.trim()).to eq('aabbaa')
    expect('aabbaa'.rtrim('a')).to eq('aabb')
    expect('aabbaa'.ltrim('a')).to eq('bbaa')
    expect("\r\n  aa bbaa  \t\n".trim()).to eq('aa bbaa')
  end

  it "offers substr helpers" do
    expect('aabbaa'.rsubstr_from('bb')).to eq('aa')
    
  end
  
end
