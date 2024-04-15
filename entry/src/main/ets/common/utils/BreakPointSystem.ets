import mediaQuery from '@ohos.mediaquery';
import BreakpointConstants from '../constants/BreakpointConstants';

export default class BreakPointSystem {
  private smListener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync(BreakpointConstants.RANGE_SM);
  private mdListener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync(BreakpointConstants.RANGE_MD);
  private lgListener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync(BreakpointConstants.RANGE_LG);

  smListenerCallback(result: mediaQuery.MediaQueryResult) {
    if (result.matches) {
      AppStorage.SetOrCreate(BreakpointConstants.CURRENT_BREAKPOINT, BreakpointConstants.BREAKPOINT_SM)
    }
  }

  mdListenerCallback(result: mediaQuery.MediaQueryResult) {
    if (result.matches) {
      AppStorage.SetOrCreate(BreakpointConstants.CURRENT_BREAKPOINT, BreakpointConstants.BREAKPOINT_MD)
    }
  }

  lgListenerCallback(result: mediaQuery.MediaQueryResult) {
    if (result.matches) {
      AppStorage.SetOrCreate(BreakpointConstants.CURRENT_BREAKPOINT, BreakpointConstants.BREAKPOINT_LG)
    }
  }

  register() {
    this.smListener.on('change', this.smListenerCallback)
    this.mdListener.on('change', this.mdListenerCallback)
    this.lgListener.on('change', this.lgListenerCallback)
  }

  unregister() {
    this.smListener.off('change', this.smListenerCallback)
    this.mdListener.off('change', this.mdListenerCallback)
    this.lgListener.off('change', this.lgListenerCallback)
  }
}