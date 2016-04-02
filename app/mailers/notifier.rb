class Notifier < ActionMailer::Base
  default :from => "notifications@twistbooks.com"

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(text).html_safe
  end
  helper_method :markdown

  def new_note(note)
    @note = note
    @book = note.chapter.book
    @comment = note.comments.first
    @account = @book.account

    mail(
      to: @book.account.owner.email,
      subject: note_subject(@book, note)
    )
  end

  def comment(comment, email)
    @book = comment.note.chapter.book
    @comment = comment
    @note = comment.note
    @account = @book.account

    mail(
      to: email,
      subject: note_subject(@book, @note)
    )
  end

  private

  def note_subject(book, note)
    "[Twist] - #{book.title} - Note ##{note.number}"
  end
end
