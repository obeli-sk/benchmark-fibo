use anyhow::{Context, ensure};
use exports::benchmark_fibo::activity::fiboa::Guest;
use obelisk::activity::process::{self as process_support};
use wasip2::io::streams::InputStream;
use wstd::{
    io::{AsyncInputStream, Cursor},
    runtime::block_on,
};

wit_bindgen::generate!({
     world: "any:any/root",
       with: {
       "wasi:io/error@0.2.3": wasip2::io::error,
       "wasi:io/poll@0.2.3": wasip2::io::poll,
       "wasi:io/streams@0.2.3": wasip2::io::streams,
       "obelisk:activity/process@1.0.0": generate,
   },
});

struct Component;
export!(Component);

async fn fibo(n: u8) -> Result<u64, anyhow::Error> {
    let exe_path = std::env::var("FIBO_EXE_PATH").context("envvar `FIBO_EXE_PATH` must be set")?;
    let proc = process_support::spawn(
        &exe_path,
        &process_support::SpawnOptions {
            args: vec![],
            environment: vec![("N".to_string(), n.to_string())],
            current_working_directory: None,
            stdin: process_support::Stdio::Discard,
            stdout: process_support::Stdio::Pipe,
            stderr: process_support::Stdio::Discard,
        },
    )?;
    println!("Waiting for {}", proc.id());
    let sub = proc.subscribe_wait();
    sub.block();
    println!("Done waiting for {}", proc.id());
    let exit_status = proc.wait()?;
    ensure!(exit_status == Some(0));
    let stdout = proc
        .take_stdout()
        .expect("first `take_stdout` must succeed");
    let stdout = stream_to_string(stdout).await?;
    println!("Got {stdout}");
    let stdout = stdout.parse().context("must be a number")?;
    Ok(stdout)
}

impl Guest for Component {
    fn fibo(n: u8) -> Result<u64, ()> {
        block_on(async move { fibo(n).await.map_err(|err| eprintln!("Got error: {err:?}")) })
    }
}

async fn stream_to_string(stream: InputStream) -> Result<String, anyhow::Error> {
    let mut buffer = Cursor::new(Vec::new());
    let stream = AsyncInputStream::new(stream);
    wstd::io::copy(stream, &mut buffer).await?;
    let output = buffer.into_inner();
    let output = String::from_utf8_lossy(&output).into_owned();
    Ok(output)
}
