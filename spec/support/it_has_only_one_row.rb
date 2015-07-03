shared_examples_for 'has only one row' do
  it 'leaves the system with only one row' do
    expect(described_class.count).to eq(1)
  end

  it 'ensures that the row is current' do
    described_class.first.tap do |row|
      expect(row.last_updated).to     eq(most_recent_time)
    end
  end

  it 'ensures the row is marked with recorded time' do
    expect(described_class.first.recorded_at).to eq(recorded_time)
  end

  it 'maintains the current view to only one row' do
    expect(current_records.count).to eq(1)
  end
end
