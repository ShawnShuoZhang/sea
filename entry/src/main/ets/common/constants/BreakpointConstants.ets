import BreakPointType from '../bean/BreakpointType';

export default class BreakpointConstants {
  static readonly BREAKPOINT_SM: string = 'sm';
  static readonly BREAKPOINT_MD: string = 'md';
  static readonly BREAKPOINT_LG: string = 'lg';
  static readonly CURRENT_BREAKPOINT: string = 'currentBreakpoint';
  static readonly RANGE_SM: string = '(320vp<=width<600vp)';
  static readonly RANGE_MD: string = '(600vp<=width<840vp)';
  static readonly RANGE_LG: string = '(840vp<=width)';
  static readonly BAR_POSITION: BreakPointType<BarPosition> = new BreakPointType({
    sm: BarPosition.End,
    md: BarPosition.Start,
    lg: BarPosition.Start
  });
}