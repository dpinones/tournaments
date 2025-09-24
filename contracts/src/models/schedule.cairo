#[derive(Copy, Drop, Serde, PartialEq, DojoStore, Introspect)]
pub struct Schedule {
    pub registration: Option<Period>,
    pub game: Period,
    pub submission_duration: u64,
}

#[derive(Copy, Drop, Serde, PartialEq, DojoStore, Introspect)]
pub struct Period {
    pub start: u64,
    pub end: u64,
}

#[derive(Copy, Drop, Serde, PartialEq)]
pub enum Phase {
    Scheduled,
    Registration,
    Staging,
    Live,
    Submission,
    Finalized,
}
