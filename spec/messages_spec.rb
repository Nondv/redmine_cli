require 'yaml'

#
# Structure is array.
# If hash[key] is hash, then it will become array like: [key] + hash_structure(hash[key]).
#
# Example:
#   hash_structure(a: 1, b: 2, c: { d: 3 }, e: 4) => [:a, :b, [:c, :d], :e]
#
def hash_structure(hash)
  hash.map do |k, v|
    v.is_a?(Hash) ? [k] + hash_structure(v) : k
  end
end

RSpec.describe 'Message files' do
  before do
    @files = {}
    Dir[File.expand_path('../../lib/assets/messages/*', __FILE__)].each do |f|
      hash = YAML.load_file f
      locale = hash.keys.first
      @files[locale] = hash[locale]
    end
  end

  it 'should have same structure' do
    standard = hash_structure(@files['en'])

    differences = []
    @files.each do |locale, hash|
      next if locale == 'en' || hash_structure(hash) == standard

      differences.push(locale)
    end

    expect(differences).to be_empty
  end
end
