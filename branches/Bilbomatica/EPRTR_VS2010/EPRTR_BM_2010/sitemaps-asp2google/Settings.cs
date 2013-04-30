using System.Configuration;

namespace SitemapConverter.Properties 
{
    internal sealed partial class Settings 
    {
        public Settings() 
        {
            SettingsLoaded += new SettingsLoadedEventHandler(Settings_SettingsLoaded);
        }

        void Settings_SettingsLoaded(object sender, SettingsLoadedEventArgs e)
        {
            if (IsFirstRun)
            {
                Upgrade();
                IsFirstRun = false;
            }
        }
    }
}
