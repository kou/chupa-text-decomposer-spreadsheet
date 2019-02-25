require "roo"
require "roo-xls"
require "digest/sha1"

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
        TARGET_EXTENSIONS.include?(data.extension) or
          TARGET_MIME_TYPES.include?(data.mime_type)
      end

      def target_score(data)
        if target?(data)
          10
        else
          nil
        end
      end

      def decompose(data)
        book = Roo::Spreadsheet.open(data.path.to_s)
        book.sheets.each do |sheet_name|
          sheet = book.sheet(sheet_name)
          body = sheet.to_csv
          text_data = TextData.new(body, source_data: data)
          text_data["name"] = sheet_name
          text_data["digest"] = Digest::SHA1.hexdigest(body)
          text_data["size"] = body.bytesize
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
