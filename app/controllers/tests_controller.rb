class TestsController < Simpler::Controller
  def index
    @time = Time.now

    render plain: "Very long text\n"
  end

  def create; end

  def show
    p params
  end
end
