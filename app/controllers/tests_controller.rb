class TestsController < Simpler::Controller

  def index
    p "hi from TestsController"
    @time = Time.now

    render plain: "Very long text\n"
  end

  def create

  end

end
