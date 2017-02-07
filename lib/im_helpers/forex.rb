module ImHelpers
  require 'nokogiri'
  # quick FOREX from BCE, only support top 28 currencies
  class Forex
    @default_dir="/tmp"
    def self.default_dir
      @default_dir
    end

    def self.default_dir=v
      @default_dir=v
    end

    def self.filename(date=Date.today)
      if date < Date.today
        "#{self.default_dir}/eurofxref-hist.xml"
      else
        "#{self.default_dir}/eurofxref-daily.xml"
      end
    end

    def self.download(date=Date.today)
      if date < Date.today
        system("wget http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.xml -O #{self.filename(date)}")
      else
        system("wget http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml -O #{self.filename(date)}")
      end
    end

    def self.parse(date=Date.today)
      fn=self.filename(date)
      if !File.exists?(fn) or date > File.ctime(fn).to_date
        self.download(date)
        @@parsed=nil
      end
      @@parsed||=Nokogiri::XML.parse(File.open(fn))
    end

    def self.rate(from_currency,to_currency,date=nil)
      if date < Date.new(1999,1,6)
        return nil
      end

      if !date
        date=Date.today
      end

      xml=self.parse(date)
      from_rate=nil
      to_rate=nil

      if from_currency=="EUR"
        from_rate=1.0
      end

      if to_currency=="EUR"
        to_rate=1.0
      end

      date_attr=date.strftime("%Y-%m-%d")

      time_node=xml.root.at("Cube").at("Cube[@time='#{date_attr}']")
      while !time_node
        ImLogger::Log.info binding, "no rate for #{date}, try #{date - 1.day}"
        date = date - 1.day
        date_attr=date.strftime("%Y-%m-%d")

        time_node=xml.root.at("Cube").at("Cube[@time='#{date_attr}']")
      end
      node=time_node.search("Cube[@currency='#{from_currency}']").first
      if node
        from_rate=node["rate"].to_f
      end
      node=time_node.search("Cube[@currency='#{to_currency}']").first
      if node
        to_rate=node["rate"].to_f
      end

      if to_rate and from_rate
        ((to_rate/from_rate)*10000.0).round/10000.0
      else
        nil
      end

    end

  end
end