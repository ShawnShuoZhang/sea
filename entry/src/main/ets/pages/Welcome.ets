import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import { CommonConstants } from '../common/constants/CommonConstants'
import window from '@ohos.window'

@Entry
@Component
struct Welcome {
  private uiContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
  private timeId: number = 0
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State countDownNumber: number = 5

  async aboutToAppear() {
    this.timeId = setInterval(() => {
      if (this.countDownNumber == 0) {
        this.route(this.timeId)
        return
      }
      this.countDownNumber--
    }, 1000)
    //获取窗口对象
    let windowClass = await window.getLastWindow(this.uiContext)
    windowClass.setWindowSystemBarEnable([]).then(() => {
      console.info('setWindowSystemBarEnable success', 'all close')
    }).catch((error) => {
      console.error('setWindowSystemBarEnable failed', error)
    })
  }

  private route(id: number) {
    clearInterval(id)
    router.replaceUrl({ url: 'pages/Home' })
  }

  build() {
    Stack() {
      //背景渐变画布
      Canvas(this.context)
        .width(CommonConstants.THOUSANDTH_1000)
        .height(CommonConstants.THOUSANDTH_1000)
        .onReady(() => {
          var grad = this.context.createLinearGradient(50, 0, 50, 500)
          grad.addColorStop(0.0, '#FF70BFF8')
          grad.addColorStop(1.0, '#FF0481DE')
          this.context.fillStyle = grad
          this.context.fillRect(0, 0, 500, 1000)
        })
        .height(CommonConstants.THOUSANDTH_1000)
      //页面主要元素
      Column() {
        //跳过按钮
        Row() {
          Button() {
            Row({ space: 5 }) {
              Text($r('app.string.skip'))
              Text(this.countDownNumber.toString())
            }
            .height(CommonConstants.THOUSANDTH_1000)
            .width(CommonConstants.THOUSANDTH_1000)
            .justifyContent(FlexAlign.Center)
          }
          .backgroundColor('#14000000')
          .borderRadius('8vp')
          .height('30vp')
          .width('60vp')
          .margin({ top: 20, right: 20 })
          .onClick(() => {
            this.route(this.timeId)
          })
        }
        .justifyContent(FlexAlign.End)
        .width(CommonConstants.THOUSANDTH_1000)

        Row() {
          Column({ space: 10 }) {
            //todo: 做一个图标，最好是有透明通道
            Image($r('app.media.ic_files_type_drive'))
              .opacity(0.5)
              .width(CommonConstants.THOUSANDTH_420)
            //todo: 应用名称或者欢迎标语
            Text($r('app.string.welcome'))
              .width(CommonConstants.THOUSANDTH_940)
              .fontSize(CommonConstants.DEFAULT_56)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
          }
          .justifyContent(FlexAlign.Center)
        }
        .layoutWeight(1)
      }

    }
    .width('100%')
    .height('100%')
  }

}
