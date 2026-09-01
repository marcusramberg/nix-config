_: {
  services.pipewire.wireplumber.extraConfig."51-mwork-audio-names" = {
    "monitor.alsa.rules" = [
      {
        # Pin internal card to the Speaker HiFi profile. WirePlumber
        # otherwise sometimes auto-selects the Headphones profile with an
        # empty jack, making the speaker sink vanish while docked.
        matches = [
          { "device.name" = "alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"; }
        ];
        actions.update-props."device.profile" = "HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)";
      }
      {
        matches = [
          { "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"; }
        ];
        actions.update-props."node.description" = "Laptop Speakers";
      }
      {
        matches = [
          { "node.name" = "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source"; }
        ];
        actions.update-props."node.description" = "Laptop Mic";
      }
      {
        matches = [
          { "node.name" = "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic2__source"; }
        ];
        actions.update-props."node.description" = "Laptop Mic (Stereo)";
      }
      {
        matches = [
          { "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI1__sink"; }
        ];
        actions.update-props."node.description" = "Laptop HDMI 1";
      }
      {
        matches = [
          { "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI2__sink"; }
        ];
        actions.update-props."node.description" = "Laptop HDMI 2";
      }
      {
        matches = [
          { "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI3__sink"; }
        ];
        actions.update-props."node.description" = "Laptop HDMI 3";
      }
      {
        matches = [
          { "node.name" = "alsa_output.usb-R__DE_Microphones_R__DE_NT-USB_Mini_934EF335-00.analog-stereo"; }
        ];
        actions.update-props."node.description" = "RØDE Mic (Monitor)";
      }
      {
        matches = [
          { "node.name" = "alsa_input.usb-R__DE_Microphones_R__DE_NT-USB_Mini_934EF335-00.mono-fallback"; }
        ];
        actions.update-props."node.description" = "RØDE Mic";
      }
      {
        matches = [
          {
            "node.name" = "alsa_output.usb-DisplayLink_Dell_Universal_Dock_D6000_1905256379-02.iec958-stereo";
          }
        ];
        actions.update-props."node.description" = "Dock Audio Out";
      }
      {
        matches = [
          {
            "node.name" = "alsa_input.usb-DisplayLink_Dell_Universal_Dock_D6000_1905256379-02.iec958-stereo";
          }
        ];
        actions.update-props."node.description" = "Dock Audio In";
      }
    ];
  };
}
