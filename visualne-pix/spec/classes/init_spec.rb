require 'spec_helper'
describe 'pix' do

  context 'with defaults for all parameters' do
    it { should contain_class('pix') }
  end
end
