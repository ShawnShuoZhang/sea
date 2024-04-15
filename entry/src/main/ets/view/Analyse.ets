import cloud, { Database } from '@hw-agconnect/cloud'
import { McLineChart, Options } from '@mcui/mccharts'
// @ts-ignore
import schema from '../../resources/rawfile/schema.json'
import { box } from '../model/box'

@Component
export default struct Analyse {
  //构造一个字符串数组，包含从今天开始往前15天的日期字符串,只显示月日
  @State dateList: string[] = Array.from({ length: 15 }, (_, i) => {
    const date = new Date()
    date.setDate(date.getDate() - i)
    return `${date.getMonth() + 1}-${date.getDate()}`
  }).reverse()
  @State o2Option: Options = new Options({
    xAxis: {
      data: this.dateList
    },
    yAxis: {
      name: '含氧量'
    },
  })
  @State phOption: Options = new Options({
    xAxis: {
      data: this.dateList
    },
    yAxis: {
      name: 'pH值'
    },
  })
  @State TempOption: Options = new Options({
    xAxis: {
      data: this.dateList
    },
    yAxis: {
      name: '温度'
    },
  })
  @State saltOption: Options = new Options({
    xAxis: {
      data: this.dateList
    },
    yAxis: {
      name: '盐度'
    },
  })
  @State nitriteOption: Options = new Options({
    xAxis: {
      data: this.dateList
    },
    yAxis: {
      name: '亚硝酸盐'
    },
  })
  @State ammoniaOption: Options = new Options({
    xAxis: {
      data: this.dateList
    },
    yAxis: {
      name: '氨氮化合物'
    },
  })
  @State options: Options[] = []
  @State name: string = ''
  private database: Database = null
  // 声明一个二维数组，用来存放数据6个维度，15个日期
  private data: number[][] = Array.from({ length: 6 }, () => new Array(15).fill(0))

  async aboutToAppear() {
    console.log('aboutToAppear', this.name)
    this.database = cloud.database({
      zoneName: 'sea',
      objectTypeInfo: schema
    })
    let boxes: box[] = await this.database.collection(box)
      .query()
      .equalTo('name', this.name)
      .orderByDesc('time')
      .limit(15)
      .get()
    boxes.forEach((value, index) => {
      this.data[0][index] = value.oxygen
      this.data[1][index] = value.ph
      this.data[2][index] = value.temperature
      this.data[3][index] = value.salt
      this.data[4][index] = value.nitrite
      this.data[5][index] = value.ammonia
    })

    this.options.push(this.o2Option, this.phOption, this.TempOption,
      this.saltOption, this.nitriteOption, this.ammoniaOption)
    // 使用Option实例对象的setVal方法来实现，修改什么属性就传什么
    this.options.forEach((option, index) => {
      option.setVal({
        series: [
          {
            // @ts-ignore
            name: option.yAxis.name,
            data: this.data[index]
          }
        ]
      })
    })
  }

  build() {
    List({ space: 10 }) {
      ForEach(this.options, (option) => {
        ListItem() {
          Column() {
            Text(option.yAxis.name)
            McLineChart({
              options: option
            })
          }
          .padding(10)
          .height('50%')
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
      })
    }
    .listDirection(Axis.Vertical) // 排列方向
    .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
    .borderRadius(10)
    .padding(10)
    .backgroundColor('#F1F3F5')
    .width('100%')
    .height('100%')
  }
}