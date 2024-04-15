@Component
export default struct Header {
  @State headerName: string = ''
  @Link changeValue: string
  @Link submitValue: string
  controller: SearchController = new SearchController()
  build() {
    Column() {
      Text(this.headerName)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Search({ value: this.changeValue, placeholder: '输入以搜索...', controller: this.controller })
        .searchButton('搜索')
        .width('90%')
        .height(40)
        .backgroundColor('#F5F5F5')
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .textFont({ size: 14, weight: 400 })
        .onSubmit((value: string) => {
          this.submitValue = value
          this.changeValue = value
        })
        .onChange((value: string) => {
          this.changeValue = value
        })
        .margin(10)
    }
    .width('100%')
    .margin({ top: 40 })
  }
}