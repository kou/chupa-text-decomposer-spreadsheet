require "roo"

module ChupaText
  module Decomposers
    class Spreadsheet < Decomposer
      registry.register("spreadsheet", self)

      TARGET_EXTENSIONS = ["ods", "xls", "xlsx", "xlsm", "xml"]

      TARGET_MIME_TYPES = [
        "application/vnd.oasis.opendocument.spreadsheet",
        "application/vnd.ms-excel",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      ]

      def target?(data)
        TARGET_EXTENSIONS.include?(data.extension) || TARGET_MIME_TYPES.include?(data.mime_type)
      end

      def decompose(data)
        book = Roo::Spreadsheet.open(data.uri)
        book.sheets.each do |sheet_name|
          sheet = book.sheet(sheet_name)
          text_data = TextData.new(sheet.to_csv)
          text_data["name"] = sheet_name
          text_data["size"] = sheet.to_csv.bytesize
          text_data["first-row"] = sheet.first_row
          text_data["last-row"] = sheet.last_row
          text_data["first-column"] = sheet.first_column && sheet.first_column_as_letter
          text_data["last-column"] = sheet.last_column && sheet.last_column_as_letter
          yield text_data
        end
        book.close
      end
    end
  end
end
