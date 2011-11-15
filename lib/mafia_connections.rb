module MafiaConnections
  def launder_money(filthy_lucre)
    laundered_money = filthy_lucre
    %w($ ,).each do |gsub_symbol|
      laundered_money.gsub!("#{gsub_symbol}", '') if laundered_money.match(Regexp.new("\\#{gsub_symbol}"))
    end

    bleached_money = laundered_money.match(/[+-]?\d*\.?\d*|\d*/)
    laundered_money = bleached_money.nil? ? 0 : bleached_money[0]
    return laundered_money
  end
end
