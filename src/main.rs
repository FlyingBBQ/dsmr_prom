extern crate serial;
extern crate dsmr5;

use std::env;
use std::time::Duration;

use std::io::prelude::*;
use serial::prelude::*;

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut port = serial::open(&args[1]).expect("Failed to open port.");

    port.reconfigure(&|settings| {
        settings.set_baud_rate(serial::Baud115200)?;
        settings.set_char_size(serial::Bits8);
        settings.set_parity(serial::ParityNone);
        settings.set_stop_bits(serial::Stop1);
        settings.set_flow_control(serial::FlowNone);
        Ok(())
    }).expect("Failed to reconfigure port.");
    port.set_timeout(Duration::from_secs(10)).expect("Failed to set timeout.");

    let reader = dsmr5::Reader::new(port.bytes().map(|b| b.unwrap()));
    for readout in reader {
        let telegram = readout.to_telegram().unwrap();
        let state = dsmr5::Result::<dsmr5::state::State>::from(&telegram).unwrap();

        println!("{}\n{}\n{}", 
            state.power_delivered.unwrap(),
            state.meterreadings[0].to.unwrap(),
            state.meterreadings[1].to.unwrap()
        );
    }
}
