export default class WaterQuality {
  oxygen: number;
  ph: number;
  temperature: number;
  salt: number;
  //亚硝酸盐
  nitrite: number;
  //氨氮
  ammonia: number;
  name: string;

  constructor(oxygen: number = 0, ph: number = 7, temperature: number = 25, salt: number = 0, nitrite: number = 0,
              ammonia: number = 0, name: string = '') {
    this.oxygen = oxygen;
    this.ph = ph;
    this.temperature = temperature;
    this.salt = salt;
    this.nitrite = nitrite;
    this.ammonia = ammonia;
    this.name = name;
  }
}
