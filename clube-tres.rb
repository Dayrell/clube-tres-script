require 'rubygems'
require 'mechanize'
require 'logger'
require 'io/console'

def define_codes(codes)
    code = 1
    num = 0
    puts 'Entre com os seus códigos. Pressione enter após cada código'
    puts 'Entre com 0 para parar de escrever seus codigos'

    loop do
        code = gets

        break if code == "0\n"
        num += 1
        codes.push(code)
    end

    return num
end

def login(email, password)
    @website = 'clube.escolhatres.com.br'

    agent = Mechanize.new
    agent.log = Logger.new "mechanize.log"

    login_page  = agent.get "http://#@website/login"

    login_form = login_page.form 

    email_field = login_form.field_with(name: "field_email")
    password_field = login_form.field_with(name: "field_senha")

    email_field.value = email
    password_field.value = password

    home_page = login_form.submit

    return agent
end

def fill_codes(email, password, codes, total)
    num = 1
    codes.each do |st|
        
            agent = login(email, password)

            code_page = agent.get "http://#@website/cadastro-pontos"

            code_form = code_page.form

            code_field = code_form.field_with(name: "field_code")
            code_field.value = st

            home_page = code_form.submit

            puts "Código #{num} de #{total} submetido com sucesso: #{st}"
            num += 1

    end
end

codes = []
num = define_codes(codes)

puts 'Digite seu email'
email = gets
puts 'Digite sua senha'
password = STDIN.noecho(&:gets)

fill_codes(email, password, codes, num)

puts 'Concluído'