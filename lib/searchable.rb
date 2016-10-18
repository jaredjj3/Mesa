require_relative 'db_connection'

module Searchable
  def where(params)
    where_str = params.map { |col_name, _| "#{ col_name } = ?" }.join(" AND ")
    table_name = self.table_name

    query = <<-SQL
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_str}
    SQL

    results = DBConnection.execute(query, *params.values)
    self.parse_all(results)
  end
end
