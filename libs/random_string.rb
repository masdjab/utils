class RandomString
  CHAR_TABLE = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

  def self.generate(length, char_table = nil)
    chars = "#{char_table}".strip.empty? ? CHAR_TABLE : char_table
    (0...length).map{|i|chars[rand(chars.length).to_i]}.join
  end
end
