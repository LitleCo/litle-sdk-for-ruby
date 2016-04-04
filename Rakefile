=begin
Copyright (c) 2011 Litle & Co.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/clean'

namespace :test do
  Rake::TestTask.new do |t|
    t.libs << '.'
    t.name = 'unit'
    t.test_files = FileList['test/unit/ts_unit.rb']
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.libs << '.'
    t.name = 'functional'
    t.test_files = FileList['test/functional/ts_all.rb']
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.libs << '.'
    t.name = 'certification'
    t.test_files = FileList['test/certification/certTest*.rb']
    t.verbose = true
  end
  
  Rake::TestTask.new do |t|
    t.libs << '.'
    t.name = 'all'
    t.test_files = FileList['test/**/*.rb']
    t.verbose = true
  end
end

task :default =>'gem'
