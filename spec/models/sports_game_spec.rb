describe SportsGame do




  describe "#all" do
    it "returns a json list of data pulled from the sports api" do
      games = SportsGame.all
      expect(games.count).to eq(4)
      expect(games.first).to be_a(SportsGame)
      expect(games.first.id).to eq(1)
    end
  end

end