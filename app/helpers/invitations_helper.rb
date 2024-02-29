module InvitationsHelper
  def invitation_status_icon(invitation, cadena)
    if cadena.users.include?(User.find_by(email: invitation.email))
      if invitation.accepted?
        inline_svg_tag('svg/check.svg', class: 'w-5 text-ciel')
      else
        inline_svg_tag('svg/question.svg', class: 'w-5 text-silver')
      end
    elsif invitation.accepted?
      inline_svg_tag('svg/check.svg', class: 'w-5 text-ciel')
    elsif invitation.accepted.nil?
      inline_svg_tag('svg/question.svg', class: 'w-5 text-silver')
    else
      inline_svg_tag('svg/cross.svg', class: 'w-5 text-pinky')
    end
  end
end
