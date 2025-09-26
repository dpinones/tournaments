pub mod components {
    pub mod constants;
    pub mod game;
    pub mod interfaces;
    pub mod libs {
        pub mod game_store;
        pub mod lifecycle;
        pub mod schedule;
        pub mod store;
        pub mod utils;
    }
    pub mod models {
        pub mod game;
        pub mod lifecycle;
        pub mod schedule;
        pub mod tournament;
    }
    pub mod tournament;
    pub mod tests {
        pub mod libs {
            pub mod store;
        }
        pub mod mocks {
            pub mod erc20_mock;
            pub mod erc721_mock;
            pub mod game_mock;
            pub mod tournament_mock;
        }
        #[cfg(test)]
        mod helpers;
        pub mod interfaces;
        #[cfg(test)]
        mod test_tournament;
        // #[cfg(test)]
    // mod test_tournament_stress_tests;
    }
}

mod presets {
    pub mod tournament;
}

#[cfg(test)]
mod tests {
    pub mod constants;
    pub mod utils;
}

