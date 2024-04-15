declare interface BreakpointOptions<T> {
  sm?: T,
  md?: T,
  lg?: T
}

export default class BreakPointType<T> {
  options: BreakpointOptions<T>

  constructor(options: BreakpointOptions<T>) {
    this.options = options
  }

  getValue(breakpoint: string): T {
    return this.options[breakpoint]
  }
}