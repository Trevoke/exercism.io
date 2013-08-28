require './test/test_helper'
require './test/integration_helper'
require './lib/app/presenters/submissions_presenter'
require './lib/exercism/submission'

class SubmissionsPresenterTest < Minitest::Test

  def test_gives_the_title_of_a_single_incomplete_revision_as_revision_1
    submission = new_submission
    submissions = [submission]
    sp = SubmissionsPresenter.new submissions: submissions
    assert_equal ['Revision 1'], sp.headers
  end

  def test_gives_the_title_of_a_single_completed_revision_as_first_and_final_with_example
    submission = new_submission
    submission.state = 'approved'
    submissions = [submission]
    sp = SubmissionsPresenter.new submissions: submissions
    assert_equal ['First & Final', 'Example'], sp.headers
  end

  def test_shows_many_submissions_with_no_completed_as_revisions_and_latest
    submission1 = new_submission
    submission2 = new_submission
    submission3 = new_submission
    submissions = [submission1, submission2, submission3]
    sp = SubmissionsPresenter.new submissions: submissions
    assert_equal ['Revision 1', 'Revision 2', 'Latest'], sp.headers
  end

  def test_shows_many_submissions_with_last_completed_as_revisions_and_final_with_example
    submission1 = new_submission
    submission2 = new_submission
    submission3 = new_submission
    submission3.state = 'approved'
    submissions = [submission1, submission2, submission3]
    sp = SubmissionsPresenter.new submissions: submissions
    assert_equal ['Revision 1', 'Revision 2', 'Final', 'Example'], sp.headers
  end

  def test_gives_the_example_for_this_exercise
    submission = new_submission
    example = 'def hello\; woof\; end'
    sp = SubmissionsPresenter.new submissions: [submission], example: example
    assert_equal example, sp.example
  end

  def test_gives_the_right_metadata_for_a_single_incomplete_revision
    submission = new_submission
    sp = SubmissionsPresenter.new submissions: [submission]
    submission_metadata = {
        title: 'Revision 1',
        submission: submission,
        html: {
            id: 'revision-1',
            style: 'display: none;'
        }
    }
    assert_equal [submission_metadata], sp.submissions_info
  end

  def test_gives_the_right_metadata_for_a_single_complete_revision
    submission = new_submission
    submission.state = 'approved'
    sp = SubmissionsPresenter.new submissions: [submission]
    submission_metadata = {
        title: 'First & Final',
        submission: submission,
        html: {
            id: 'revision-1',
            style: 'display: none;'
        }
    }
    #{ title: "Example",
    #  html: { id: "revision-example", style: "display: none;" },
    #  code: Exercism.current_curriculum.in(after.language).assign(after.slug).example,
    #  language: after.language }
    example_metadata = {
        title: 'Example',
        submission: submission,
        html: {
            id: 'revision-example',
            style: 'display: none;'
        }
    }
    assert_equal [submission_metadata], sp.submissions_info
  end


  private

  def exercise
    Exercise.new('nong', 'one')
  end

  def new_submission
    Submission.on(exercise)
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