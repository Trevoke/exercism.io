class SubmissionsPresenter

  def initialize(args={})
    @submissions = args.fetch :submissions
    @example = args.fetch(:example, nil)
  end

  def headers
    @headers ||= create_headers
  end

  def submissions_info
#    <% iterations.each_with_index do |iteration,index| %>
#
#      <%= erb :"code/submission", locals:
#{ title: "Revision #{index + 1}",
#          html:
#{ id: "revision-#{index + 1}", style: "display: none;" },
#          submission: iteration } %>
#
#    <% end %>
    [{
        title: 'Revision 1',
        submission: submissions.first,
        html: {
            id: 'revision-1',
            style: 'display: none;'
        }
    }]
  end

  def example
    @example
  end

  private

  def create_headers
    if submissions.count == 1
      submissions_are_approved? ? ['First & Final', 'Example'] : revision_headers
    else
      if submissions_are_approved?
        headers = revision_headers
        headers[-1] = 'Final'
        headers << 'Example'
        headers
      else
        headers = revision_headers
        headers[-1] = 'Latest'
        headers
      end
    end
  end

  def submissions
    @submissions
  end

  def revision_headers
    submissions.each_with_index.map { |x, i| "Revision #{i+1}" }
  end

  def submissions_are_approved?
    submissions.map(&:state).include?('approved')
  end

  def submissions_are_not_approved?
    !submissions_are_approved?
  end

end