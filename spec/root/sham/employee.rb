class Employee < User
end

Sham.config(Employee) do |c|
  c.attributes do
    {
      name: "Employee #{Sham.string!}",
      email: "#{Sham.string!}@company.com"
    }
  end
end
