
describe user('root') do
  it { should exist }
  skip 'This is an example test, replace with your own test.'
  not_if os.windows?
end

describe port(80) do
  it { should_not be_listening }
  skip 'This is an example test, replace with your own test.'
end
