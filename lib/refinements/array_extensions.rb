module Refinements
  module ArrayExtensions
    refine Array do
      def compress
        self.compact.reject(&:empty?)
      end

      def compress!
        self.replace(compress)
      end
    end
  end
end
