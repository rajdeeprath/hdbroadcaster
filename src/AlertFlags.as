package
{
	public class AlertFlags
	{
		
		private static const FLAGS    : Vector.<String> = Vector.<String>( [ "Yes", "Cancel" ] );
		
		public static function get flags():Vector.<String>
		{
			return FLAGS.concat();
		}
		
	}
}