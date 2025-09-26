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

#[derive(Copy, Drop, Serde, PartialEq, DojoStore, Default, Introspect)]
pub enum Phase {
    #[default]
    Scheduled,
    Registration,
    Staging,
    Live,
    Submission,
    Finalized,
}
