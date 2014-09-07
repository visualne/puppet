require 'spec_helper'
describe 'openSwan' do

  context 'with defaults for all parameters' do
    it { should contain_class('openSwan') }
  end
end
