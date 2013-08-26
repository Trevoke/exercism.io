require './test/api_helper'
require 'mocha/setup'

class ExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def setup
    @alice = User.create(username: 'alice', github_id: 1, email: 'alice@example.com')
  end

  def teardown
    Mongoid.reset
  end

  def logged_in
    { github_id: @alice.github_id }
  end

  def test_exercise_gallery
    User.any_instance.expects(:completed?).returns(true)
    get "/completed/ruby/bob", {}, 'rack.session' => logged_in
    assert_equal 200, last_response.status
  end

end

=begin
require './test/api_helper'

class ExercisesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def setup
    user
  end

  def teardown
    Mongoid.reset
  end

  def user
    @user ||= User.create({
      username: username,
      github_id: 'github',
      email: "#{username}@example.com",
      current: { language => exercise }
    })
  end

  def logged_in
    { github_id: user.github_id }
  end

  def username
    @username ||= 'submitter'
  end

  def language
    @language ||= 'ruby'
  end

  def exercise
    @exercise ||= 'bob'
  end

  def generate_submissions args
    count = args.fetch :count, 1
    approved = args.fetch :approved, false
    attempt = Attempt.new(user, 'class Bob\nend', 'bob.rb').save
    if approved
      submission = Submission.last
      submission.state = 'approved'
      submission.save
    end
  end

  def test_a_single_unapproved_submission_is_as_revision_1
    generate_submissions count: 1, approved: false
    get "/#{username}/#{language}/#{exercise}", {}, 'rack.session' => logged_in
    assert last_response.body.include?('Revision 1'), 'Revision title not found'
    assert !last_response.body.include?('Start'), 'Start revision has been found'
    assert !last_response.body.include?('Latest'), 'End revision has been found'
  end

  def test_a_single_approved_submission_is_first_and_final
    generate_submissions count: 1, approved: true
    get "/#{username}/#{language}/#{exercise}", {}, 'rack.session' => logged_in
    assert last_response.body.include?('First & Final'), 'Revision title not found'
    assert !last_response.body.include?('Revision 1'), 'Numbered revision found'
  end
end
=end