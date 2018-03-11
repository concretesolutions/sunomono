require 'sunomono'

describe Sunomono do

  before(:each) do
    @directory     = Dir.pwd
  end

  after(:each) do
    Dir.chdir(@directory)
    FileUtils.rm_rf(@project_name)
  end

  context 'Should return the latest version of sunonomo' do
    it 'Returns the latest version' do
      stdout  = `sunomono version`
      version = "Sunomono Version " + "#{Sunomono::VERSION}"

      expect(version).
          to include(stdout.gsub(/\n/, ""))
    end
  end
end