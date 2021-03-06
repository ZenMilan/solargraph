describe Solargraph::Pin::Method do
  it "tracks code parameters" do
    source = Solargraph::Source.new(%(
      def foo bar, baz = MyClass.new
      end
    ))
    pin = source.pins.select{|pin| pin.path == '#foo'}.first
    expect(pin.parameters.length).to eq(2)
    expect(pin.parameters[0]).to eq('bar')
    expect(pin.parameters[1]).to eq('baz = MyClass.new')
  end

  it "tracks keyword parameters" do
    source = Solargraph::Source.new(%(
      def foo bar:, baz: MyClass.new
      end
    ))
    pin = source.pins.select{|pin| pin.path == '#foo'}.first
    expect(pin.parameters.length).to eq(2)
    expect(pin.parameters[0]).to eq('bar:')
    expect(pin.parameters[1]).to eq('baz: MyClass.new')
  end

  it "includes param tags in documentation" do
    source = Solargraph::Source.new(%(
      class Foo
        # @param one [First] description1
        # @param two [Second] description2
        def bar one, two
        end
      end
    ))
    pin = source.pins.select{|pin| pin.path == 'Foo#bar'}.first
    expect(pin.documentation).to include('one')
    expect(pin.documentation).to include('[First]')
    expect(pin.documentation).to include('description1')
    expect(pin.documentation).to include('two')
    expect(pin.documentation).to include('[Second]')
    expect(pin.documentation).to include('description2')
  end

  it "detects return types from tags" do
    source = Solargraph::Source.new(%(
      # @return [Hash]
      def foo bar:, baz: MyClass.new
      end
    ))
    pin = source.pins.select{|pin| pin.path == '#foo'}.first
    expect(pin.return_type).to eq('Hash')
  end
end
