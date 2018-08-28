require 'spec_helper'

describe 'smartmontools_version', :type => :fact do
  before(:each) { Facter.clear }

  context 'smartd fact not set' do
    it 'should return nil' do
      Facter.fact(:smartd).stubs(:value).returns(nil)
      expect(Facter.fact(:smartmontools_version).value).to be_nil
    end
  end

  context 'smartd fact is broken' do
    it 'should return nil' do
      Facter.fact(:smartd).stubs(:value).returns('foobar')
      expect(Facter.fact(:smartmontools_version).value).to be_nil
    end
  end

  context 'smartd fact is working' do
    it 'should get the version string' do
      Facter.fact(:smartd).stubs(:value).returns('/usr/sbin/smartd')
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/sbin/smartd --version').
        returns(File.read(fixtures('smartd', 'version-smartmontools-5.42-2.el5')))
      expect(Facter.fact(:smartmontools_version).value).to eq('5.42')
    end

    it 'should get the version string' do
      Facter.fact(:smartd).stubs(:value).returns('/usr/sbin/smartd')
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/sbin/smartd --version').
        returns(File.read(fixtures('smartd', 'version-smartmontools-5.43-1.el6.x86_64')))
      expect(Facter.fact(:smartmontools_version).value).to eq('5.43')
    end
  end
end
