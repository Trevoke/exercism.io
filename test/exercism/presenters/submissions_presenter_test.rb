require './test/test_helper'
require './test/integration_helper'
require './lib/exercism/presenters/submissions_presenter'
require './lib/exercism/submission'


class SubmissionsPresenterTest < Minitest::Test

  def exercise
    Exercise.new('nong', 'one')
  end

  def test_gives_the_title_of_a_single_incomplete_revision_as_revision_1
    submission = Submission.on(exercise)
    submissions = [submission]
    sp = SubmissionsPresenter.new submissions
    assert_equal ['Revision 1'], sp.headers
  end

  def test_gives_the_title_of_a_single_completed_revision_as_first_and_final_with_example
    submission = Submission.on(exercise)
    submission.state = 'approved'
    submissions = [submission]
    sp = SubmissionsPresenter.new submissions
    assert_equal ['First & Final', 'Example'], sp.headers
  end

  def test_shows_many_submissions_with_no_completed_as_revisions_and_latest
    submission1 = Submission.on(exercise)
    submission2 = Submission.on(exercise)
    submission3 = Submission.on(exercise)
    submissions = [submission1, submission2, submission3]
    sp = SubmissionsPresenter.new submissions
    assert_equal ['Revision 1', 'Revision 2', 'Latest'], sp.headers
  end

  def test_shows_many_submissions_with_last_completed_as_revisions_and_final_with_example
    submission1 = Submission.on(exercise)
    submission2 = Submission.on(exercise)
    submission3 = Submission.on(exercise)
    submission3.state = 'approved'
    submissions = [submission1, submission2, submission3]
    sp = SubmissionsPresenter.new submissions
    assert_equal ['Revision 1', 'Revision 2', 'Final', 'Example'], sp.headers
  end

end

=begin
1 submission, not completed: Revision 1
1 submission, completed: First & Final
Many submissions, not completed: Revision 1 , Revision 2,..., Latest
Many submissions, not completed: Revision 1 , Revision 2,..., Final

Let's select only Revision 1 if there's a single revision.
If there's more then Revision 1 and Latest or Final.

 the Example is available but never selected by default,
=end