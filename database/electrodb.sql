-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 12, 2026 at 12:46 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `electrodb`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `parent_category_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `parent_category_id`, `name`, `description`) VALUES
(1, NULL, 'Electronic Components', 'Reference catalogue for electronic components and circuits.'),
(2, 1, 'Digital Electronics', 'Digital logic and sequential/combinational circuits.'),
(3, 2, 'Sequential Logic', 'Digital circuits whose outputs depend on stored state.'),
(4, 3, 'Counters', 'Sequential circuits that advance through defined states.'),
(5, 3, 'Flip-Flops', 'Clocked bistable circuits that store one bit.'),
(6, 2, 'Combinational Logic', 'Digital circuits whose outputs depend on current inputs.'),
(7, 6, 'Logic Gates', 'Basic Boolean logic gates.'),
(8, 6, 'Multiplexers', 'Circuits that select one of multiple data inputs.'),
(9, 6, 'Encoders and Decoders', 'Circuits that translate coded digital inputs and outputs.'),
(10, 1, 'Semiconductor Components', 'Semiconductor devices and integrated circuits.'),
(11, 10, 'Diodes', 'Two-terminal semiconductor devices.'),
(12, 11, 'Rectifier Diodes', 'Diodes commonly used for rectification.'),
(13, 11, 'Zener Diodes', 'Diodes designed for reverse-breakdown operation.'),
(14, 11, 'Schottky Diodes', 'Metal-semiconductor junction diodes.'),
(15, 11, 'Light-Emitting Diodes', 'Diodes that emit light when forward biased.'),
(16, 10, 'Transistors', 'Semiconductor devices used for switching and amplification.'),
(17, 16, 'Bipolar Junction Transistors', 'Current-controlled bipolar transistor devices.'),
(18, 16, 'MOSFETs', 'Voltage-controlled field-effect transistor devices.'),
(19, 1, 'Analog Electronics', 'Analog circuits and signal-processing configurations.'),
(20, 19, 'Operational Amplifier Circuits', 'Common circuits built around operational amplifiers.'),
(21, 1, 'Power Electronics', 'Components and circuits used to control electrical power.'),
(22, 21, 'Voltage Regulators', 'Circuits and devices that regulate output voltage.'),
(23, 1, 'Sensors', 'Devices that measure physical quantities.'),
(24, 23, 'Temperature Sensors', 'Devices that measure temperature.'),
(25, 1, 'Data Conversion ICs', 'Integrated circuits that convert analog and digital representations.'),
(26, 25, 'Analog-to-Digital Converters', 'Circuits that convert analog input levels into digital codes.'),
(27, 10, 'Memory ICs', 'Integrated circuits that store digital information.'),
(28, 1, 'Electromechanical Components', 'Components combining electrical and mechanical behavior.'),
(29, 28, 'Relays', 'Electrically actuated switches.'),
(30, 28, 'DC Motors', 'Motors powered by direct current.');

-- --------------------------------------------------------

--
-- Table structure for table `category_content_types`
--

CREATE TABLE `category_content_types` (
  `category_id` int(11) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 0,
  `display_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `category_content_types`
--

INSERT INTO `category_content_types` (`category_id`, `content_type_id`, `is_required`, `display_order`) VALUES
(4, 1, 0, 6),
(4, 3, 1, 4),
(4, 6, 1, 2),
(4, 8, 1, 3),
(4, 9, 1, 1),
(4, 10, 0, 5),
(4, 15, 0, 7),
(5, 1, 1, 1),
(5, 2, 1, 2),
(5, 5, 1, 3),
(5, 6, 1, 4),
(5, 7, 1, 5),
(5, 8, 1, 6),
(7, 1, 1, 1),
(7, 3, 0, 5),
(7, 4, 0, 4),
(7, 11, 1, 2),
(7, 12, 1, 3),
(7, 15, 0, 6),
(8, 1, 1, 1),
(8, 3, 0, 4),
(8, 8, 0, 5),
(8, 12, 1, 3),
(8, 13, 1, 2),
(9, 1, 1, 1),
(9, 3, 0, 4),
(9, 11, 1, 2),
(9, 12, 1, 3),
(12, 3, 1, 2),
(12, 4, 1, 1),
(12, 14, 1, 3),
(12, 15, 1, 4),
(12, 29, 0, 5),
(13, 3, 1, 2),
(13, 4, 1, 1),
(13, 14, 1, 3),
(13, 15, 1, 4),
(14, 3, 1, 2),
(14, 4, 1, 1),
(14, 14, 1, 3),
(14, 15, 1, 4),
(15, 3, 1, 2),
(15, 4, 1, 1),
(15, 15, 1, 3),
(15, 16, 1, 4),
(17, 1, 1, 1),
(17, 3, 1, 3),
(17, 4, 1, 2),
(17, 15, 1, 6),
(17, 17, 0, 4),
(17, 18, 1, 5),
(18, 1, 1, 1),
(18, 3, 1, 3),
(18, 4, 1, 2),
(18, 15, 1, 6),
(18, 18, 1, 4),
(18, 19, 1, 5),
(20, 1, 1, 1),
(20, 3, 1, 2),
(20, 6, 1, 3),
(20, 20, 0, 4),
(20, 21, 0, 5),
(22, 1, 1, 1),
(22, 3, 1, 2),
(22, 15, 1, 4),
(22, 20, 0, 3),
(22, 22, 0, 5),
(24, 1, 1, 1),
(24, 3, 0, 2),
(24, 15, 1, 4),
(24, 20, 1, 3),
(24, 22, 0, 5),
(26, 1, 1, 1),
(26, 4, 0, 6),
(26, 8, 0, 4),
(26, 15, 1, 5),
(26, 22, 1, 2),
(26, 23, 1, 3),
(27, 1, 1, 1),
(27, 15, 1, 5),
(27, 22, 1, 2),
(27, 24, 0, 3),
(27, 25, 0, 4),
(29, 1, 1, 1),
(29, 3, 1, 4),
(29, 4, 1, 2),
(29, 15, 1, 5),
(29, 26, 1, 3),
(30, 1, 1, 1),
(30, 3, 1, 3),
(30, 4, 1, 2),
(30, 15, 1, 5),
(30, 27, 0, 4);

-- --------------------------------------------------------

--
-- Table structure for table `components`
--

CREATE TABLE `components` (
  `component_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(50) DEFAULT NULL,
  `short_description` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `working_principle` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `circuit_symbol_url` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `components`
--

INSERT INTO `components` (`component_id`, `category_id`, `name`, `slug`, `short_description`, `description`, `working_principle`, `image_url`, `circuit_symbol_url`) VALUES
(1, 4, 'Decade Counter', 'decade-counter', 'A counter that cycles through ten states, from 0 through 9.', 'A decade counter represents ten states using four bits.', 'At each active clock edge, the count increments; after 1001, the next state is 0000.', '/images/counters/decade-counter.svg', NULL),
(2, 4, 'Mod-8 Up Counter', 'mod-8-up-counter', 'A three-bit counter with eight states.', 'Cycles through binary states 000 to 111.', 'Each active clock edge increments the count modulo 8.', '/images/counters/mod8-counter.svg', NULL),
(3, 4, '4-Bit Binary Up Counter', '4-bit-binary-up-counter', 'A four-bit counter that counts upward from 0 to 15.', 'A synchronous or asynchronous four-bit counter has sixteen states.', 'Each active clock edge increments the count modulo 16.', '/images/counters/4bit-up-counter.svg', NULL),
(4, 4, '4-Bit Binary Down Counter', '4-bit-binary-down-counter', 'A four-bit counter that counts downward from 15 to 0.', 'The counter decrements its four-bit state on each active clock event.', 'After 0000, the next state wraps to 1111.', '/images/counters/4bit-down-counter.svg', NULL),
(5, 4, 'Up/Down Counter', 'up-down-counter', 'A counter with selectable increment and decrement operation.', 'A direction input determines whether the count increases or decreases.', 'On each active clock edge, the state increments or decrements according to the direction input.', '/images/counters/up-down-counter.svg', NULL),
(6, 5, 'SR Flip-Flop', 'sr-flip-flop', 'A one-bit storage element with set and reset inputs.', 'The SR flip-flop stores one bit using set and reset controls.', 'S sets Q, R resets Q; S=R=1 is invalid for the basic active-high SR form.', '/images/flip-flops/sr.svg', '/images/flip-flops/sr-symbol.svg'),
(7, 5, 'JK Flip-Flop', 'jk-flip-flop', 'A one-bit storage element with hold, set, reset, and toggle operations.', 'A clocked bistable circuit with J and K control inputs.', 'At the active clock edge, 00 holds, 01 resets, 10 sets, and 11 toggles Q.', '/images/flip-flops/jk.svg', '/images/flip-flops/jk-symbol.svg'),
(8, 5, 'D Flip-Flop', 'd-flip-flop', 'A one-bit storage element that samples D at the active clock edge.', 'The D input is transferred to Q at the active clock edge.', 'At the active edge, the next state equals D; between edges Q holds.', '/images/flip-flops/d.svg', '/images/flip-flops/d-symbol.svg'),
(9, 5, 'T Flip-Flop', 't-flip-flop', 'A one-bit storage element that holds or toggles.', 'The T input determines whether the stored state is retained or complemented.', 'T=0 holds the state and T=1 toggles the state at the active clock edge.', '/images/flip-flops/t.svg', '/images/flip-flops/t-symbol.svg'),
(10, 5, 'Master-Slave JK Flip-Flop', 'master-slave-jk-flip-flop', 'A JK flip-flop arrangement that reduces race-around behavior.', 'Two cascaded latches respond to opposite clock phases.', 'The master captures input during one clock phase and the slave updates the output during the other.', '/images/flip-flops/master-slave-jk.svg', '/images/flip-flops/jk-symbol.svg'),
(11, 7, 'AND Gate', 'and-gate', 'Output is high only when all inputs are high.', 'A two-input AND gate performs logical conjunction.', 'The output is 1 only when both inputs are 1.', '/images/logic-gates/and.svg', '/images/logic-gates/and-symbol.svg'),
(12, 7, 'OR Gate', 'or-gate', 'Output is high when at least one input is high.', 'A two-input OR gate performs logical disjunction.', 'The output is 1 when either input or both inputs are 1.', '/images/logic-gates/or.svg', '/images/logic-gates/or-symbol.svg'),
(13, 7, 'NOT Gate', 'not-gate', 'A single-input gate that inverts its input.', 'The inverter produces the complement of its input.', 'A low input produces a high output and vice versa.', '/images/logic-gates/not.svg', '/images/logic-gates/not-symbol.svg'),
(14, 7, 'NAND Gate', 'nand-gate', 'Output is the complement of AND.', 'A two-input NAND gate performs AND followed by inversion.', 'The output is 0 only when both inputs are 1.', '/images/logic-gates/nand.svg', '/images/logic-gates/nand-symbol.svg'),
(15, 7, 'NOR Gate', 'nor-gate', 'Output is the complement of OR.', 'A two-input NOR gate performs OR followed by inversion.', 'The output is 1 only when both inputs are 0.', '/images/logic-gates/nor.svg', '/images/logic-gates/nor-symbol.svg'),
(16, 7, 'XOR Gate', 'xor-gate', 'Output is high when the two inputs differ.', 'The exclusive-OR gate detects unequal binary inputs.', 'The output is 1 when exactly one input is 1.', '/images/logic-gates/xor.svg', '/images/logic-gates/xor-symbol.svg'),
(17, 7, 'XNOR Gate', 'xnor-gate', 'Output is high when the two inputs are equal.', 'The exclusive-NOR gate is the complement of XOR.', 'The output is 1 when both inputs match.', '/images/logic-gates/xnor.svg', '/images/logic-gates/xnor-symbol.svg'),
(18, 8, '2-to-1 Multiplexer', '2-to-1-multiplexer', 'Routes one of two data inputs to a single output.', 'A select input chooses between I0 and I1.', 'S=0 selects I0; S=1 selects I1.', '/images/multiplexers/2-to-1-mux.svg', NULL),
(19, 8, '4-to-1 Multiplexer', '4-to-1-multiplexer', 'Selects one of four data inputs.', 'Two select lines choose one of four inputs.', 'S1S0 selects I0, I1, I2, or I3 for codes 00, 01, 10, or 11.', '/images/multiplexers/4-to-1-mux.svg', NULL),
(20, 8, '8-to-1 Multiplexer', '8-to-1-multiplexer', 'Selects one of eight data inputs using three select lines.', 'An 8-to-1 MUX routes one selected input to its output.', 'The three-bit select code chooses one of I0 through I7.', '/images/multiplexers/8-to-1-mux.svg', NULL),
(21, 9, '2-to-4 Decoder', '2-to-4-decoder', 'Activates one of four outputs for a two-bit input code.', 'An active-high decoder maps A1A0 to one of four outputs.', 'Only the output corresponding to the input code is high.', '/images/decoders/2-to-4-decoder.svg', NULL),
(22, 9, '3-to-8 Decoder', '3-to-8-decoder', 'Decodes a three-bit input into eight one-hot outputs.', 'The decoder activates one output for each binary input code.', 'For input k, output Yk is high and the remaining outputs are low.', '/images/decoders/3-to-8-decoder.svg', NULL),
(23, 9, '4-to-2 Priority Encoder', '4-to-2-priority-encoder', 'Encodes the highest-priority active input into a two-bit code.', 'A priority encoder resolves multiple active inputs according to priority.', 'The output represents the highest-priority asserted input; a valid flag can indicate any active input.', '/images/encoders/4-to-2-priority-encoder.svg', NULL),
(24, 12, 'Rectifier Diode', 'rectifier-diode', 'A diode commonly used to rectify AC into pulsating DC.', 'A PN-junction diode conducts in forward bias and blocks reverse current within its ratings.', 'Forward bias permits current; reverse bias largely blocks current until breakdown.', '/images/diodes/rectifier-diode.svg', '/images/diodes/rectifier-symbol.svg'),
(25, 13, 'Zener Diode', 'zener-diode', 'A diode designed for reverse-breakdown operation.', 'A Zener diode provides a reference or shunt-regulated voltage within its operating limits.', 'In reverse breakdown, voltage remains approximately near its specified Zener voltage over a suitable current range.', '/images/diodes/zener-diode.svg', '/images/diodes/zener-symbol.svg'),
(26, 14, 'Schottky Diode', 'schottky-diode', 'A fast metal-semiconductor diode with typically low forward voltage.', 'A Schottky diode uses a metal-semiconductor junction.', 'Majority-carrier conduction enables fast switching; forward drop and reverse leakage depend on the part.', '/images/diodes/schottky-diode.svg', '/images/diodes/schottky-symbol.svg'),
(27, 15, 'Red LED', 'red-led', 'A light-emitting diode that emits red light when forward biased.', 'An LED converts electrical energy into visible light.', 'Radiative recombination emits light; use a suitable current-limiting resistor or driver.', '/images/diodes/red-led.svg', '/images/diodes/led-symbol.svg'),
(28, 15, 'Green LED', 'green-led', 'A light-emitting diode that emits green light.', 'A green LED emits light when forward current passes through its junction.', 'Forward current causes radiative recombination; electrical ratings depend on the selected LED.', '/images/diodes/green-led.svg', '/images/diodes/led-symbol.svg'),
(29, 17, 'NPN Bipolar Transistor', 'npn-bipolar-transistor', 'An NPN transistor used for switching and amplification.', 'An NPN BJT has base, collector, and emitter terminals.', 'In the active region, base current controls collector current approximately according to current gain.', '/images/transistors/npn-bjt.svg', '/images/transistors/npn-symbol.svg'),
(30, 17, 'PNP Bipolar Transistor', 'pnp-bipolar-transistor', 'A PNP transistor used for high-side switching and amplification.', 'A PNP BJT uses holes as majority carriers and has base, collector, and emitter terminals.', 'Conduction is controlled by the base-emitter voltage and current; polarity is opposite to an NPN device.', '/images/transistors/pnp-bjt.svg', '/images/transistors/pnp-symbol.svg'),
(31, 18, 'N-Channel Enhancement MOSFET', 'n-channel-enhancement-mosfet', 'A voltage-controlled transistor commonly used as a switch.', 'A positive gate-to-source voltage can form a conductive channel.', 'A sufficient gate drive enhances the channel; threshold voltage alone does not guarantee low on-resistance.', '/images/transistors/n-channel-mosfet.svg', '/images/transistors/nmos-symbol.svg'),
(32, 18, 'P-Channel Enhancement MOSFET', 'p-channel-enhancement-mosfet', 'A voltage-controlled transistor often used for high-side switching.', 'A P-channel enhancement MOSFET forms a channel when gate voltage is sufficiently below source voltage.', 'Gate-to-source voltage controls channel conduction; ratings and gate-drive needs depend on the part.', '/images/transistors/p-channel-mosfet.svg', '/images/transistors/pmos-symbol.svg'),
(33, 20, 'Inverting Amplifier', 'inverting-amplifier', 'An op-amp circuit with inverted output polarity.', 'The input signal passes through Rin to the inverting input and Rf provides feedback.', 'For ideal linear operation, voltage gain is the negative feedback-to-input resistance ratio.', '/images/op-amp/inverting-amplifier.svg', NULL),
(34, 20, 'Non-Inverting Amplifier', 'non-inverting-amplifier', 'An op-amp circuit whose output is in phase with its input.', 'The signal is applied to the non-inverting input and a feedback divider sets gain.', 'For ideal linear operation, gain is one plus the feedback-to-ground resistance ratio.', '/images/op-amp/non-inverting-amplifier.svg', NULL),
(35, 20, 'Voltage Follower', 'voltage-follower', 'A unity-gain buffer with high input and low output impedance.', 'The output is directly connected to the inverting input.', 'Negative feedback drives the output toward the input voltage within the op-amp limits.', '/images/op-amp/voltage-follower.svg', NULL),
(36, 22, 'Fixed Linear Voltage Regulator', 'fixed-linear-voltage-regulator', 'Maintains a nominal fixed output voltage within operating limits.', 'A feedback loop controls a pass element to regulate output voltage.', 'An internal reference and error amplifier adjust the pass element; dropout and thermal limits apply.', '/images/regulators/linear-regulator.svg', NULL),
(37, 22, 'Adjustable Linear Voltage Regulator', 'adjustable-linear-voltage-regulator', 'Provides an adjustable regulated DC output.', 'An external resistor network sets the target output voltage.', 'Feedback compares a sampled output against an internal reference and controls the pass element.', '/images/regulators/adjustable-linear-regulator.svg', NULL),
(38, 24, 'Analog Temperature Sensor', 'analog-temperature-sensor', 'Produces an analog signal related to temperature.', 'The sensor converts temperature into voltage or current according to its transfer function.', 'Temperature is inferred from the output using the selected device\'s transfer function and calibration.', '/images/sensors/analog-temperature-sensor.svg', NULL),
(39, 24, 'NTC Thermistor', 'ntc-thermistor', 'A resistor whose resistance decreases as temperature increases.', 'An NTC thermistor has a negative temperature coefficient.', 'Resistance decreases nonlinearly as temperature rises; a divider can convert resistance to voltage.', '/images/sensors/ntc-thermistor.svg', NULL),
(40, 26, 'Successive Approximation ADC', 'successive-approximation-adc', 'An ADC that determines a digital code through successive bit trials.', 'A SAR ADC typically includes a sample-and-hold, comparator, DAC, SAR logic, and control circuitry.', 'The SAR tests candidate bits from most significant to least significant to approximate the sampled input.', '/images/adcs/sar-adc.svg', NULL),
(41, 27, 'EEPROM', 'eeprom', 'Non-volatile memory that can be electrically erased and reprogrammed.', 'EEPROM retains stored data without power; capacity, interface, timing, and endurance depend on the part.', 'Address and control logic select locations for reads and writes; writes take longer and have finite endurance.', '/images/memory/eeprom.svg', NULL),
(42, 27, 'SRAM', 'static-ram', 'Volatile memory that stores bits using bistable cells.', 'SRAM stores each bit in a latch-like cell while power is applied.', 'Read and write circuitry accesses addressed cells; data is lost when supply power is removed.', '/images/memory/sram.svg', NULL),
(43, 29, 'Electromagnetic Relay', 'electromagnetic-relay', 'An electrically actuated switch using a coil and mechanical contacts.', 'A coil creates a magnetic field that moves an armature and changes contact states.', 'When coil current reaches actuation conditions, contacts change state; a DC coil commonly needs flyback protection.', '/images/relays/electromagnetic-relay.svg', '/images/relays/relay-symbol.svg'),
(44, 30, 'Brushed DC Motor', 'brushed-dc-motor', 'Converts DC electrical energy into rotational motion.', 'Armature current, a magnetic field, brushes, and a commutator produce torque.', 'Current-carrying conductors experience force in a magnetic field; the commutator switches current as the rotor turns.', '/images/motors/brushed-dc-motor.svg', '/images/motors/dc-motor-symbol.svg');

-- --------------------------------------------------------

--
-- Table structure for table `component_content`
--

CREATE TABLE `component_content` (
  `content_id` int(11) NOT NULL,
  `component_id` int(11) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `content` longtext NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `component_content`
--

INSERT INTO `component_content` (`content_id`, `component_id`, `content_type_id`, `title`, `content`, `display_order`) VALUES
(1, 1, 28, 'Working Principle', 'At each active clock edge, the count increments; after 1001, the next state is 0000.', 1),
(2, 1, 9, 'State Table', '[{\"current\":\"0000\",\"next\":\"0001\"},{\"current\":\"0001\",\"next\":\"0010\"},{\"current\":\"0010\",\"next\":\"0011\"},{\"current\":\"0011\",\"next\":\"0100\"},{\"current\":\"0100\",\"next\":\"0101\"},{\"current\":\"0101\",\"next\":\"0110\"},{\"current\":\"0110\",\"next\":\"0111\"},{\"current\":\"0111\",\"next\":\"1000\"},{\"current\":\"1000\",\"next\":\"1001\"},{\"current\":\"1001\",\"next\":\"0000\"}]', 2),
(3, 1, 6, 'Characteristic Equation', 'Q_{t+1} = (Q_t + 1) \\bmod 10', 3),
(4, 2, 28, 'Working Principle', 'Each active clock edge increments the count modulo 8.', 1),
(5, 2, 9, 'State Table', '[{\"current\":\"000\",\"next\":\"001\"},{\"current\":\"001\",\"next\":\"010\"},{\"current\":\"010\",\"next\":\"011\"},{\"current\":\"011\",\"next\":\"100\"},{\"current\":\"100\",\"next\":\"101\"},{\"current\":\"101\",\"next\":\"110\"},{\"current\":\"110\",\"next\":\"111\"},{\"current\":\"111\",\"next\":\"000\"}]', 2),
(6, 2, 6, 'Characteristic Equation', 'Q_{t+1} = (Q_t + 1) \\bmod 8', 3),
(7, 3, 28, 'Working Principle', 'Each active clock edge increments the count modulo 16.', 1),
(8, 3, 9, 'State Table', '[{\"current\":\"0000\",\"next\":\"0001\"},{\"current\":\"0001\",\"next\":\"0010\"},{\"current\":\"0010\",\"next\":\"0011\"},{\"current\":\"0011\",\"next\":\"0100\"},{\"current\":\"0100\",\"next\":\"0101\"},{\"current\":\"0101\",\"next\":\"0110\"},{\"current\":\"0110\",\"next\":\"0111\"},{\"current\":\"0111\",\"next\":\"1000\"},{\"current\":\"1000\",\"next\":\"1001\"},{\"current\":\"1001\",\"next\":\"1010\"},{\"current\":\"1010\",\"next\":\"1011\"},{\"current\":\"1011\",\"next\":\"1100\"},{\"current\":\"1100\",\"next\":\"1101\"},{\"current\":\"1101\",\"next\":\"1110\"},{\"current\":\"1110\",\"next\":\"1111\"},{\"current\":\"1111\",\"next\":\"0000\"}]', 2),
(9, 3, 6, 'Characteristic Equation', 'Q_{t+1} = (Q_t + 1) \\bmod 16', 3),
(10, 4, 28, 'Working Principle', 'After 0000, the next state wraps to 1111.', 1),
(11, 4, 9, 'State Table', '[{\"current\":\"0000\",\"next\":\"1111\"},{\"current\":\"0001\",\"next\":\"0000\"},{\"current\":\"0010\",\"next\":\"0001\"},{\"current\":\"0011\",\"next\":\"0010\"},{\"current\":\"0100\",\"next\":\"0011\"},{\"current\":\"0101\",\"next\":\"0100\"},{\"current\":\"0110\",\"next\":\"0101\"},{\"current\":\"0111\",\"next\":\"0110\"},{\"current\":\"1000\",\"next\":\"0111\"},{\"current\":\"1001\",\"next\":\"1000\"},{\"current\":\"1010\",\"next\":\"1001\"},{\"current\":\"1011\",\"next\":\"1010\"},{\"current\":\"1100\",\"next\":\"1011\"},{\"current\":\"1101\",\"next\":\"1100\"},{\"current\":\"1110\",\"next\":\"1101\"},{\"current\":\"1111\",\"next\":\"1110\"}]', 2),
(12, 4, 6, 'Characteristic Equation', 'Q_{t+1} = (Q_t - 1) \\bmod 16', 3),
(13, 5, 28, 'Working Principle', 'On each active clock edge, the state increments or decrements according to the direction input.', 1),
(14, 6, 28, 'Working Principle', 'S sets Q, R resets Q; S=R=1 is invalid for the basic active-high SR form.', 1),
(15, 6, 5, 'Characteristic Table', '[{\"S\":0,\"R\":0,\"Q_t\":\"Q_t\",\"Q_next\":\"Q_t\",\"operation\":\"Hold\"},{\"S\":0,\"R\":1,\"Q_t\":\"X\",\"Q_next\":0,\"operation\":\"Reset\"},{\"S\":1,\"R\":0,\"Q_t\":\"X\",\"Q_next\":1,\"operation\":\"Set\"},{\"S\":1,\"R\":1,\"Q_t\":\"X\",\"Q_next\":\"Invalid\",\"operation\":\"Invalid\"}]', 2),
(16, 6, 6, 'Characteristic Equation', 'Q_{t+1} = S + \\overline{R}Q_t,\\quad SR\\ne 11', 3),
(17, 7, 28, 'Working Principle', 'At the active clock edge, 00 holds, 01 resets, 10 sets, and 11 toggles Q.', 1),
(18, 7, 5, 'Characteristic Table', '[{\"J\":0,\"K\":0,\"operation\":\"Hold\",\"Q_next\":\"Q_t\"},{\"J\":0,\"K\":1,\"operation\":\"Reset\",\"Q_next\":0},{\"J\":1,\"K\":0,\"operation\":\"Set\",\"Q_next\":1},{\"J\":1,\"K\":1,\"operation\":\"Toggle\",\"Q_next\":\"\\\\overline{Q_t}\"}]', 2),
(19, 7, 7, 'Excitation Table', '[{\"Q_t\":0,\"Q_next\":0,\"J\":0,\"K\":\"X\"},{\"Q_t\":0,\"Q_next\":1,\"J\":1,\"K\":\"X\"},{\"Q_t\":1,\"Q_next\":0,\"J\":\"X\",\"K\":1},{\"Q_t\":1,\"Q_next\":1,\"J\":\"X\",\"K\":0}]', 3),
(20, 7, 6, 'Characteristic Equation', 'Q_{t+1} = J\\overline{Q_t} + \\overline{K}Q_t', 4),
(21, 7, 8, 'Timing Diagram', '/images/flip-flops/jk-flip-flop.timing.svg', 5),
(22, 8, 28, 'Working Principle', 'At the active edge, the next state equals D; between edges Q holds.', 1),
(23, 8, 5, 'Characteristic Table', '[{\"D\":0,\"Q_next\":0},{\"D\":1,\"Q_next\":1}]', 2),
(24, 8, 6, 'Characteristic Equation', 'Q_{t+1} = D', 3),
(25, 8, 8, 'Timing Diagram', '/images/flip-flops/d-flip-flop.timing.svg', 4),
(26, 9, 28, 'Working Principle', 'T=0 holds the state and T=1 toggles the state at the active clock edge.', 1),
(27, 9, 5, 'Characteristic Table', '[{\"T\":0,\"Q_t\":0,\"Q_next\":0},{\"T\":0,\"Q_t\":1,\"Q_next\":1},{\"T\":1,\"Q_t\":0,\"Q_next\":1},{\"T\":1,\"Q_t\":1,\"Q_next\":0}]', 2),
(28, 9, 6, 'Characteristic Equation', 'Q_{t+1} = T \\oplus Q_t', 3),
(29, 9, 8, 'Timing Diagram', '/images/flip-flops/t-flip-flop.timing.svg', 4),
(30, 10, 28, 'Working Principle', 'The master captures input during one clock phase and the slave updates the output during the other.', 1),
(31, 10, 5, 'Characteristic Table', '[{\"J\":0,\"K\":0,\"operation\":\"Hold\",\"Q_next\":\"Q_t\"},{\"J\":0,\"K\":1,\"operation\":\"Reset\",\"Q_next\":0},{\"J\":1,\"K\":0,\"operation\":\"Set\",\"Q_next\":1},{\"J\":1,\"K\":1,\"operation\":\"Toggle\",\"Q_next\":\"\\\\overline{Q_t}\"}]', 2),
(32, 10, 7, 'Excitation Table', '[{\"Q_t\":0,\"Q_next\":0,\"J\":0,\"K\":\"X\"},{\"Q_t\":0,\"Q_next\":1,\"J\":1,\"K\":\"X\"},{\"Q_t\":1,\"Q_next\":0,\"J\":\"X\",\"K\":1},{\"Q_t\":1,\"Q_next\":1,\"J\":\"X\",\"K\":0}]', 3),
(33, 10, 6, 'Characteristic Equation', 'Q_{t+1} = J\\overline{Q_t} + \\overline{K}Q_t', 4),
(34, 10, 8, 'Timing Diagram', '/images/flip-flops/master-slave-jk-flip-flop.timing.svg', 5),
(35, 11, 28, 'Working Principle', 'The output is 1 only when both inputs are 1.', 1),
(36, 11, 11, 'Truth Table', '[{\"A\":0,\"B\":0,\"Y\":0},{\"A\":0,\"B\":1,\"Y\":0},{\"A\":1,\"B\":0,\"Y\":0},{\"A\":1,\"B\":1,\"Y\":1}]', 2),
(37, 11, 12, 'Boolean Equation', 'Y = A \\cdot B', 3),
(38, 12, 28, 'Working Principle', 'The output is 1 when either input or both inputs are 1.', 1),
(39, 12, 11, 'Truth Table', '[{\"A\":0,\"B\":0,\"Y\":0},{\"A\":0,\"B\":1,\"Y\":1},{\"A\":1,\"B\":0,\"Y\":1},{\"A\":1,\"B\":1,\"Y\":1}]', 2),
(40, 12, 12, 'Boolean Equation', 'Y = A + B', 3),
(41, 13, 28, 'Working Principle', 'A low input produces a high output and vice versa.', 1),
(42, 13, 11, 'Truth Table', '[{\"A\":0,\"Y\":1},{\"A\":1,\"Y\":0}]', 2),
(43, 13, 12, 'Boolean Equation', 'Y = \\overline{A}', 3),
(44, 14, 28, 'Working Principle', 'The output is 0 only when both inputs are 1.', 1),
(45, 14, 11, 'Truth Table', '[{\"A\":0,\"B\":0,\"Y\":1},{\"A\":0,\"B\":1,\"Y\":1},{\"A\":1,\"B\":0,\"Y\":1},{\"A\":1,\"B\":1,\"Y\":0}]', 2),
(46, 14, 12, 'Boolean Equation', 'Y = \\overline{A \\cdot B}', 3),
(47, 15, 28, 'Working Principle', 'The output is 1 only when both inputs are 0.', 1),
(48, 15, 11, 'Truth Table', '[{\"A\":0,\"B\":0,\"Y\":1},{\"A\":0,\"B\":1,\"Y\":0},{\"A\":1,\"B\":0,\"Y\":0},{\"A\":1,\"B\":1,\"Y\":0}]', 2),
(49, 15, 12, 'Boolean Equation', 'Y = \\overline{A+B}', 3),
(50, 16, 28, 'Working Principle', 'The output is 1 when exactly one input is 1.', 1),
(51, 16, 11, 'Truth Table', '[{\"A\":0,\"B\":0,\"Y\":0},{\"A\":0,\"B\":1,\"Y\":1},{\"A\":1,\"B\":0,\"Y\":1},{\"A\":1,\"B\":1,\"Y\":0}]', 2),
(52, 16, 12, 'Boolean Equation', 'Y = A \\oplus B', 3),
(53, 17, 28, 'Working Principle', 'The output is 1 when both inputs match.', 1),
(54, 17, 11, 'Truth Table', '[{\"A\":0,\"B\":0,\"Y\":1},{\"A\":0,\"B\":1,\"Y\":0},{\"A\":1,\"B\":0,\"Y\":0},{\"A\":1,\"B\":1,\"Y\":1}]', 2),
(55, 17, 12, 'Boolean Equation', 'Y = \\overline{A \\oplus B}', 3),
(56, 18, 28, 'Working Principle', 'S=0 selects I0; S=1 selects I1.', 1),
(57, 18, 13, 'Selection Table', '[{\"S0\":0,\"Y\":\"I0\"},{\"S0\":1,\"Y\":\"I1\"}]', 2),
(58, 18, 12, 'Boolean Equation', 'Y = \\overline{S}I_0 + SI_1', 3),
(59, 19, 28, 'Working Principle', 'S1S0 selects I0, I1, I2, or I3 for codes 00, 01, 10, or 11.', 1),
(60, 19, 13, 'Selection Table', '[{\"S0\":0,\"S1\":0,\"Y\":\"I0\"},{\"S0\":0,\"S1\":1,\"Y\":\"I1\"},{\"S0\":1,\"S1\":0,\"Y\":\"I2\"},{\"S0\":1,\"S1\":1,\"Y\":\"I3\"}]', 2),
(61, 19, 12, 'Boolean Equation', 'Y = \\overline{S_1}\\overline{S_0}I_0 + \\overline{S_1}S_0I_1 + S_1\\overline{S_0}I_2 + S_1S_0I_3', 3),
(62, 20, 28, 'Working Principle', 'The three-bit select code chooses one of I0 through I7.', 1),
(63, 20, 13, 'Selection Table', '[{\"S0\":0,\"S1\":0,\"S2\":0,\"Y\":\"I0\"},{\"S0\":0,\"S1\":0,\"S2\":1,\"Y\":\"I1\"},{\"S0\":0,\"S1\":1,\"S2\":0,\"Y\":\"I2\"},{\"S0\":0,\"S1\":1,\"S2\":1,\"Y\":\"I3\"},{\"S0\":1,\"S1\":0,\"S2\":0,\"Y\":\"I4\"},{\"S0\":1,\"S1\":0,\"S2\":1,\"Y\":\"I5\"},{\"S0\":1,\"S1\":1,\"S2\":0,\"Y\":\"I6\"},{\"S0\":1,\"S1\":1,\"S2\":1,\"Y\":\"I7\"}]', 2),
(64, 20, 12, 'Boolean Equation', 'Y = \\sum_{i=0}^{7} m_i I_i', 3),
(65, 21, 28, 'Working Principle', 'Only the output corresponding to the input code is high.', 1),
(66, 21, 11, 'Truth Table', '[{\"A0\":0,\"A1\":0,\"Y0\":1,\"Y1\":0,\"Y2\":0,\"Y3\":0},{\"A0\":0,\"A1\":1,\"Y0\":0,\"Y1\":1,\"Y2\":0,\"Y3\":0},{\"A0\":1,\"A1\":0,\"Y0\":0,\"Y1\":0,\"Y2\":1,\"Y3\":0},{\"A0\":1,\"A1\":1,\"Y0\":0,\"Y1\":0,\"Y2\":0,\"Y3\":1}]', 2),
(67, 21, 12, 'Boolean Equations', 'Y_0=\\overline{A_1}\\overline{A_0},\\;Y_1=\\overline{A_1}A_0,\\;Y_2=A_1\\overline{A_0},\\;Y_3=A_1A_0', 3),
(68, 22, 28, 'Working Principle', 'For input k, output Yk is high and the remaining outputs are low.', 1),
(69, 22, 11, 'Truth Table', '[{\"A0\":0,\"A1\":0,\"A2\":0,\"Y0\":1,\"Y1\":0,\"Y2\":0,\"Y3\":0,\"Y4\":0,\"Y5\":0,\"Y6\":0,\"Y7\":0},{\"A0\":0,\"A1\":0,\"A2\":1,\"Y0\":0,\"Y1\":1,\"Y2\":0,\"Y3\":0,\"Y4\":0,\"Y5\":0,\"Y6\":0,\"Y7\":0},{\"A0\":0,\"A1\":1,\"A2\":0,\"Y0\":0,\"Y1\":0,\"Y2\":1,\"Y3\":0,\"Y4\":0,\"Y5\":0,\"Y6\":0,\"Y7\":0},{\"A0\":0,\"A1\":1,\"A2\":1,\"Y0\":0,\"Y1\":0,\"Y2\":0,\"Y3\":1,\"Y4\":0,\"Y5\":0,\"Y6\":0,\"Y7\":0},{\"A0\":1,\"A1\":0,\"A2\":0,\"Y0\":0,\"Y1\":0,\"Y2\":0,\"Y3\":0,\"Y4\":1,\"Y5\":0,\"Y6\":0,\"Y7\":0},{\"A0\":1,\"A1\":0,\"A2\":1,\"Y0\":0,\"Y1\":0,\"Y2\":0,\"Y3\":0,\"Y4\":0,\"Y5\":1,\"Y6\":0,\"Y7\":0},{\"A0\":1,\"A1\":1,\"A2\":0,\"Y0\":0,\"Y1\":0,\"Y2\":0,\"Y3\":0,\"Y4\":0,\"Y5\":0,\"Y6\":1,\"Y7\":0},{\"A0\":1,\"A1\":1,\"A2\":1,\"Y0\":0,\"Y1\":0,\"Y2\":0,\"Y3\":0,\"Y4\":0,\"Y5\":0,\"Y6\":0,\"Y7\":1}]', 2),
(70, 22, 12, 'Boolean Equations', 'Y_k=1\\text{ when }(A_2A_1A_0)_2=k,\\quad k=0,\\ldots,7', 3),
(71, 23, 28, 'Working Principle', 'The output represents the highest-priority asserted input; a valid flag can indicate any active input.', 1),
(72, 23, 13, 'Priority Table', '[{\"D3\":1,\"D2\":\"X\",\"D1\":\"X\",\"D0\":\"X\",\"Y1\":1,\"Y0\":1,\"valid\":1},{\"D3\":0,\"D2\":1,\"D1\":\"X\",\"D0\":\"X\",\"Y1\":1,\"Y0\":0,\"valid\":1},{\"D3\":0,\"D2\":0,\"D1\":1,\"D0\":\"X\",\"Y1\":0,\"Y0\":1,\"valid\":1},{\"D3\":0,\"D2\":0,\"D1\":0,\"D0\":1,\"Y1\":0,\"Y0\":0,\"valid\":1},{\"D3\":0,\"D2\":0,\"D1\":0,\"D0\":0,\"Y1\":0,\"Y0\":0,\"valid\":0}]', 2),
(73, 23, 12, 'Boolean Equations', 'Y_1 = D_3 + D_2,\\quad Y_0 = D_3 + \\overline{D_2}D_1', 3),
(74, 24, 28, 'Working Principle', 'Forward bias permits current; reverse bias largely blocks current until breakdown.', 1),
(75, 24, 4, 'Circuit Symbol', '/images/diodes/rectifier-symbol.svg', 2),
(76, 24, 14, 'I-V Characteristic Curve', '/images/diodes/rectifier-diode-iv-curve.svg', 3),
(77, 25, 28, 'Working Principle', 'In reverse breakdown, voltage remains approximately near its specified Zener voltage over a suitable current range.', 1),
(78, 25, 4, 'Circuit Symbol', '/images/diodes/zener-symbol.svg', 2),
(79, 25, 14, 'I-V Characteristic Curve', '/images/diodes/zener-diode-iv-curve.svg', 3),
(80, 26, 28, 'Working Principle', 'Majority-carrier conduction enables fast switching; forward drop and reverse leakage depend on the part.', 1),
(81, 26, 4, 'Circuit Symbol', '/images/diodes/schottky-symbol.svg', 2),
(82, 26, 14, 'I-V Characteristic Curve', '/images/diodes/schottky-diode-iv-curve.svg', 3),
(83, 27, 28, 'Working Principle', 'Radiative recombination emits light; use a suitable current-limiting resistor or driver.', 1),
(84, 27, 4, 'Circuit Symbol', '/images/diodes/led-symbol.svg', 2),
(85, 27, 14, 'I-V Characteristic Curve', '/images/diodes/red-led-iv-curve.svg', 3),
(86, 28, 28, 'Working Principle', 'Forward current causes radiative recombination; electrical ratings depend on the selected LED.', 1),
(87, 28, 4, 'Circuit Symbol', '/images/diodes/led-symbol.svg', 2),
(88, 28, 14, 'I-V Characteristic Curve', '/images/diodes/green-led-iv-curve.svg', 3),
(89, 29, 28, 'Working Principle', 'In the active region, base current controls collector current approximately according to current gain.', 1),
(90, 29, 4, 'Circuit Symbol', '/images/transistors/npn-symbol.svg', 2),
(91, 29, 3, 'Typical Switching Circuit', '/images/transistors/npn-bipolar-transistor-switch.svg', 3),
(92, 30, 28, 'Working Principle', 'Conduction is controlled by the base-emitter voltage and current; polarity is opposite to an NPN device.', 1),
(93, 30, 4, 'Circuit Symbol', '/images/transistors/pnp-symbol.svg', 2),
(94, 30, 3, 'Typical Switching Circuit', '/images/transistors/pnp-bipolar-transistor-switch.svg', 3),
(95, 31, 28, 'Working Principle', 'A sufficient gate drive enhances the channel; threshold voltage alone does not guarantee low on-resistance.', 1),
(96, 31, 4, 'Circuit Symbol', '/images/transistors/nmos-symbol.svg', 2),
(97, 31, 3, 'Typical Switching Circuit', '/images/transistors/n-channel-enhancement-mosfet-switch.svg', 3),
(98, 32, 28, 'Working Principle', 'Gate-to-source voltage controls channel conduction; ratings and gate-drive needs depend on the part.', 1),
(99, 32, 4, 'Circuit Symbol', '/images/transistors/pmos-symbol.svg', 2),
(100, 32, 3, 'Typical Switching Circuit', '/images/transistors/p-channel-enhancement-mosfet-switch.svg', 3),
(101, 33, 28, 'Working Principle', 'For ideal linear operation, voltage gain is the negative feedback-to-input resistance ratio.', 1),
(102, 33, 3, 'Circuit Diagram', '/images/op-amp/inverting-amplifier.svg', 2),
(103, 33, 6, 'Characteristic Equation', 'A_v = \\frac{V_{out}}{V_{in}} = -\\frac{R_f}{R_{in}}', 3),
(104, 34, 28, 'Working Principle', 'For ideal linear operation, gain is one plus the feedback-to-ground resistance ratio.', 1),
(105, 34, 3, 'Circuit Diagram', '/images/op-amp/non-inverting-amplifier.svg', 2),
(106, 34, 6, 'Characteristic Equation', 'A_v = 1 + \\frac{R_f}{R_g}', 3),
(107, 35, 28, 'Working Principle', 'Negative feedback drives the output toward the input voltage within the op-amp limits.', 1),
(108, 35, 3, 'Circuit Diagram', '/images/op-amp/voltage-follower.svg', 2),
(109, 35, 6, 'Characteristic Equation', 'V_{out} = V_{in},\\quad A_v = 1', 3),
(110, 36, 28, 'Working Principle', 'An internal reference and error amplifier adjust the pass element; dropout and thermal limits apply.', 1),
(111, 36, 1, 'Block Diagram', '/images/regulators/linear-regulator.svg', 2),
(112, 36, 3, 'Typical Application Diagram', '/images/regulators/linear-regulator.svg', 3),
(113, 37, 28, 'Working Principle', 'Feedback compares a sampled output against an internal reference and controls the pass element.', 1),
(114, 37, 1, 'Block Diagram', '/images/regulators/adjustable-linear-regulator.svg', 2),
(115, 37, 3, 'Typical Application Diagram', '/images/regulators/adjustable-linear-regulator.svg', 3),
(116, 38, 28, 'Working Principle', 'Temperature is inferred from the output using the selected device\'s transfer function and calibration.', 1),
(117, 38, 1, 'Block Diagram', '/images/sensors/analog-temperature-sensor.svg', 2),
(118, 38, 3, 'Typical Application Diagram', '/images/sensors/analog-temperature-sensor.svg', 3),
(119, 39, 28, 'Working Principle', 'Resistance decreases nonlinearly as temperature rises; a divider can convert resistance to voltage.', 1),
(120, 39, 6, 'Characteristic Equation', 'R(T)=R_0\\exp\\left[B\\left(\\frac{1}{T}-\\frac{1}{T_0}\\right)\\right]', 2),
(121, 40, 28, 'Working Principle', 'The SAR tests candidate bits from most significant to least significant to approximate the sampled input.', 1),
(122, 40, 6, 'Characteristic Equation', '\\text{LSB size} \\approx \\frac{V_{FS}}{2^N}', 2),
(123, 41, 28, 'Working Principle', 'Address and control logic select locations for reads and writes; writes take longer and have finite endurance.', 1),
(124, 41, 1, 'Block Diagram', '/images/memory/eeprom.svg', 2),
(125, 41, 3, 'Typical Application Diagram', '/images/memory/eeprom.svg', 3),
(126, 42, 28, 'Working Principle', 'Read and write circuitry accesses addressed cells; data is lost when supply power is removed.', 1),
(127, 42, 1, 'Block Diagram', '/images/memory/sram.svg', 2),
(128, 42, 3, 'Typical Application Diagram', '/images/memory/sram.svg', 3),
(129, 43, 28, 'Working Principle', 'When coil current reaches actuation conditions, contacts change state; a DC coil commonly needs flyback protection.', 1),
(130, 43, 4, 'Circuit Symbol', '/images/relays/relay-symbol.svg', 2),
(131, 43, 3, 'Typical Application Circuit', '/images/relays/electromagnetic-relay.svg', 3),
(132, 44, 28, 'Working Principle', 'Current-carrying conductors experience force in a magnetic field; the commutator switches current as the rotor turns.', 1),
(133, 44, 6, 'Characteristic Equation', '\\tau \\propto I_a,\\quad E_b \\propto \\omega', 2);

-- --------------------------------------------------------

--
-- Table structure for table `component_specifications`
--

CREATE TABLE `component_specifications` (
  `component_id` int(11) NOT NULL,
  `specification_id` int(11) NOT NULL,
  `value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `component_specifications`
--

INSERT INTO `component_specifications` (`component_id`, `specification_id`, `value`) VALUES
(1, 1, '10'),
(1, 2, '4'),
(2, 1, '8'),
(2, 2, '3'),
(3, 1, '16'),
(3, 2, '4'),
(4, 1, '16'),
(4, 2, '4'),
(5, 2, 'n (design-dependent)'),
(7, 2, '1'),
(8, 2, '1'),
(9, 2, '1'),
(11, 21, '2'),
(11, 22, '1'),
(12, 21, '2'),
(12, 22, '1'),
(13, 21, '1'),
(13, 22, '1'),
(14, 21, '2'),
(14, 22, '1'),
(15, 21, '2'),
(15, 22, '1'),
(16, 21, '2'),
(16, 22, '1'),
(17, 21, '2'),
(17, 22, '1'),
(18, 22, '1'),
(18, 23, '2'),
(18, 24, '1'),
(19, 22, '1'),
(19, 23, '4'),
(19, 24, '2'),
(20, 22, '1'),
(20, 23, '8'),
(20, 24, '3'),
(21, 21, '2'),
(21, 22, '4'),
(22, 21, '3'),
(22, 22, '8'),
(23, 21, '4'),
(23, 22, '2'),
(33, 12, '-10 (illustrative resistor ratio)'),
(34, 12, '11 (illustrative resistor ratio)'),
(40, 15, '10 (illustrative resolution; no specific IC selected)'),
(41, 16, '8192 (illustrative; equals 1024 bytes)');

-- --------------------------------------------------------

--
-- Table structure for table `component_tag`
--

CREATE TABLE `component_tag` (
  `component_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `component_tag`
--

INSERT INTO `component_tag` (`component_id`, `tag_id`) VALUES
(1, 19),
(1, 23),
(1, 30),
(1, 52),
(1, 88),
(2, 19),
(2, 23),
(2, 30),
(2, 53),
(2, 88),
(3, 14),
(3, 23),
(3, 30),
(3, 88),
(3, 101),
(4, 14),
(4, 23),
(4, 30),
(4, 32),
(4, 88),
(5, 19),
(5, 23),
(5, 30),
(5, 88),
(5, 102),
(6, 30),
(6, 39),
(6, 88),
(6, 90),
(6, 92),
(7, 30),
(7, 39),
(7, 44),
(7, 88),
(7, 92),
(8, 24),
(8, 30),
(8, 39),
(8, 88),
(8, 92),
(9, 30),
(9, 39),
(9, 88),
(9, 92),
(9, 96),
(10, 30),
(10, 39),
(10, 44),
(10, 49),
(10, 88),
(11, 13),
(11, 16),
(11, 21),
(11, 30),
(11, 47),
(12, 16),
(12, 21),
(12, 30),
(12, 47),
(12, 68),
(13, 16),
(13, 21),
(13, 30),
(13, 42),
(13, 47),
(14, 21),
(14, 30),
(14, 47),
(14, 58),
(14, 100),
(15, 21),
(15, 30),
(15, 47),
(15, 62),
(15, 100),
(16, 21),
(16, 30),
(16, 47),
(16, 70),
(16, 107),
(17, 21),
(17, 30),
(17, 36),
(17, 47),
(17, 106),
(18, 1),
(18, 21),
(18, 26),
(18, 30),
(18, 56),
(19, 4),
(19, 21),
(19, 26),
(19, 30),
(19, 56),
(20, 6),
(20, 21),
(20, 26),
(20, 30),
(20, 56),
(21, 2),
(21, 21),
(21, 29),
(21, 30),
(21, 65),
(22, 3),
(22, 21),
(22, 29),
(22, 30),
(22, 65),
(23, 5),
(23, 21),
(23, 30),
(23, 35),
(23, 75),
(24, 31),
(24, 71),
(24, 73),
(24, 77),
(24, 86),
(25, 31),
(25, 79),
(25, 82),
(25, 86),
(25, 104),
(26, 31),
(26, 37),
(26, 48),
(26, 85),
(26, 86),
(27, 31),
(27, 45),
(27, 67),
(27, 78),
(27, 86),
(28, 31),
(28, 40),
(28, 45),
(28, 67),
(28, 86),
(29, 15),
(29, 63),
(29, 86),
(29, 93),
(29, 98),
(30, 15),
(30, 41),
(30, 72),
(30, 86),
(30, 98),
(31, 54),
(31, 57),
(31, 86),
(31, 93),
(31, 98),
(32, 41),
(32, 54),
(32, 69),
(32, 86),
(32, 98),
(33, 10),
(33, 11),
(33, 43),
(33, 59),
(33, 66),
(34, 10),
(34, 11),
(34, 59),
(34, 60),
(34, 66),
(35, 11),
(35, 18),
(35, 59),
(35, 66),
(35, 99),
(36, 28),
(36, 38),
(36, 46),
(36, 74),
(36, 105),
(37, 9),
(37, 28),
(37, 46),
(37, 74),
(37, 105),
(38, 12),
(38, 50),
(38, 87),
(38, 94),
(38, 97),
(39, 64),
(39, 81),
(39, 87),
(39, 94),
(39, 95),
(40, 8),
(40, 25),
(40, 30),
(40, 83),
(40, 84),
(41, 27),
(41, 33),
(41, 51),
(41, 61),
(41, 89),
(42, 27),
(42, 51),
(42, 76),
(42, 91),
(42, 103),
(43, 20),
(43, 22),
(43, 34),
(43, 80),
(43, 93),
(44, 7),
(44, 17),
(44, 28),
(44, 34),
(44, 55);

-- --------------------------------------------------------

--
-- Table structure for table `content_types`
--

CREATE TABLE `content_types` (
  `content_type_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `data_format` enum('TEXT','IMAGE','TABLE','EQUATION','DIAGRAM','TIMING_DIAGRAM','GRAPH','DOCUMENT') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `content_types`
--

INSERT INTO `content_types` (`content_type_id`, `name`, `data_format`) VALUES
(1, 'Box Diagram', 'DIAGRAM'),
(2, 'NAND Circuit Diagram', 'DIAGRAM'),
(3, 'Circuit Diagram', 'DIAGRAM'),
(4, 'Circuit Symbol', 'IMAGE'),
(5, 'Characteristic Table', 'TABLE'),
(6, 'Characteristic Equation', 'EQUATION'),
(7, 'Excitation Table', 'TABLE'),
(8, 'Timing Diagram', 'TIMING_DIAGRAM'),
(9, 'State Table', 'TABLE'),
(10, 'State Diagram', 'DIAGRAM'),
(11, 'Truth Table', 'TABLE'),
(12, 'Boolean Equation', 'EQUATION'),
(13, 'Selection Table', 'TABLE'),
(14, 'I-V Characteristic Curve', 'GRAPH'),
(15, 'Electrical Specifications', 'TABLE'),
(16, 'Applications', 'TEXT'),
(17, 'Input Characteristics', 'GRAPH'),
(18, 'Output Characteristics', 'GRAPH'),
(19, 'Transfer Characteristics', 'GRAPH'),
(20, 'Input-Output Characteristics', 'GRAPH'),
(21, 'Frequency Response', 'GRAPH'),
(22, 'Internal Block Diagram', 'DIAGRAM'),
(23, 'Conversion Process', 'TEXT'),
(24, 'Read Operation Timing Diagram', 'TIMING_DIAGRAM'),
(25, 'Write Operation Timing Diagram', 'TIMING_DIAGRAM'),
(26, 'Internal Contact Diagram', 'DIAGRAM'),
(27, 'Torque-Speed Characteristics', 'GRAPH'),
(28, 'Working Principle', 'TEXT'),
(29, 'Datasheet', 'DOCUMENT');

-- --------------------------------------------------------

--
-- Table structure for table `specifications`
--

CREATE TABLE `specifications` (
  `specification_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `unit` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `specifications`
--

INSERT INTO `specifications` (`specification_id`, `name`, `unit`) VALUES
(1, 'Number of States', NULL),
(2, 'Number of Bits', 'bits'),
(3, 'Supply Voltage', 'V'),
(4, 'Maximum Clock Frequency', 'MHz'),
(5, 'Propagation Delay', 'ns'),
(6, 'Forward Voltage', 'V'),
(7, 'Maximum Forward Current', 'mA'),
(8, 'Zener Voltage', 'V'),
(9, 'Collector Current', 'A'),
(10, 'Drain-Source Voltage', 'V'),
(11, 'Gate Threshold Voltage', 'V'),
(12, 'Voltage Gain', NULL),
(13, 'Output Voltage', 'V'),
(14, 'Measurement Range', '°C'),
(15, 'Resolution', 'bits'),
(16, 'Memory Capacity', 'bits'),
(17, 'Coil Voltage', 'V'),
(18, 'Rated Voltage', 'V'),
(19, 'No-Load Speed', 'RPM'),
(20, 'Contact Configuration', NULL),
(21, 'Number of Inputs', NULL),
(22, 'Number of Outputs', NULL),
(23, 'Number of Data Inputs', NULL),
(24, 'Number of Select Lines', NULL),
(25, 'Maximum Output Current', 'A'),
(26, 'Input Voltage Range', 'V'),
(27, 'Sample Rate', 'samples/s'),
(28, 'Write Endurance', 'cycles'),
(29, 'Rated Contact Current', 'A'),
(30, 'Stall Current', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE `tags` (
  `tag_id` int(11) NOT NULL,
  `tag_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`tag_id`, `tag_name`) VALUES
(1, '2-to-1'),
(2, '2-to-4'),
(3, '3-to-8'),
(4, '4-to-1'),
(5, '4-to-2'),
(6, '8-to-1'),
(7, 'actuator'),
(8, 'adc'),
(9, 'adjustable-output'),
(10, 'amplifier'),
(11, 'analog'),
(12, 'analog-output'),
(13, 'and'),
(14, 'binary'),
(15, 'bjt'),
(16, 'boolean-algebra'),
(17, 'brushed'),
(18, 'buffer'),
(19, 'clocked'),
(20, 'coil'),
(21, 'combinational-logic'),
(22, 'contacts'),
(23, 'counter'),
(24, 'd-type'),
(25, 'data-conversion'),
(26, 'data-selection'),
(27, 'data-storage'),
(28, 'dc'),
(29, 'decoder'),
(30, 'digital'),
(31, 'diode'),
(32, 'down-counter'),
(33, 'eeprom'),
(34, 'electromechanical'),
(35, 'encoder'),
(36, 'equivalence'),
(37, 'fast-switching'),
(38, 'fixed-output'),
(39, 'flip-flop'),
(40, 'green-light'),
(41, 'high-side'),
(42, 'inverter'),
(43, 'inverting'),
(44, 'jk'),
(45, 'led'),
(46, 'linear'),
(47, 'logic-gate'),
(48, 'low-forward-voltage'),
(49, 'master-slave'),
(50, 'measurement'),
(51, 'memory'),
(52, 'mod-10'),
(53, 'mod-8'),
(54, 'mosfet'),
(55, 'motor'),
(56, 'multiplexer'),
(57, 'n-channel'),
(58, 'nand'),
(59, 'negative-feedback'),
(60, 'non-inverting'),
(61, 'non-volatile'),
(62, 'nor'),
(63, 'npn'),
(64, 'ntc'),
(65, 'one-hot'),
(66, 'op-amp'),
(67, 'optoelectronic'),
(68, 'or'),
(69, 'p-channel'),
(70, 'parity'),
(71, 'pn-junction'),
(72, 'pnp'),
(73, 'power'),
(74, 'power-electronics'),
(75, 'priority'),
(76, 'random-access'),
(77, 'rectification'),
(78, 'red-light'),
(79, 'regulation'),
(80, 'relay'),
(81, 'resistive'),
(82, 'reverse-breakdown'),
(83, 'sampling'),
(84, 'sar'),
(85, 'schottky'),
(86, 'semiconductor'),
(87, 'sensor'),
(88, 'sequential-logic'),
(89, 'serial-interface'),
(90, 'sr'),
(91, 'sram'),
(92, 'storage'),
(93, 'switching'),
(94, 'temperature'),
(95, 'thermistor'),
(96, 'toggle'),
(97, 'transducer'),
(98, 'transistor'),
(99, 'unity-gain'),
(100, 'universal-gate'),
(101, 'up-counter'),
(102, 'up-down'),
(103, 'volatile'),
(104, 'voltage-reference'),
(105, 'voltage-regulator'),
(106, 'xnor'),
(107, 'xor');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD KEY `idx_categories_parent` (`parent_category_id`);

--
-- Indexes for table `category_content_types`
--
ALTER TABLE `category_content_types`
  ADD PRIMARY KEY (`category_id`,`content_type_id`),
  ADD KEY `content_type_id` (`content_type_id`);

--
-- Indexes for table `components`
--
ALTER TABLE `components`
  ADD PRIMARY KEY (`component_id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_components_category` (`category_id`),
  ADD KEY `idx_components_name` (`name`);

--
-- Indexes for table `component_content`
--
ALTER TABLE `component_content`
  ADD PRIMARY KEY (`content_id`),
  ADD KEY `content_type_id` (`content_type_id`),
  ADD KEY `idx_component_content_order` (`component_id`,`display_order`);

--
-- Indexes for table `component_specifications`
--
ALTER TABLE `component_specifications`
  ADD PRIMARY KEY (`component_id`,`specification_id`),
  ADD KEY `specification_id` (`specification_id`);

--
-- Indexes for table `component_tag`
--
ALTER TABLE `component_tag`
  ADD PRIMARY KEY (`component_id`,`tag_id`),
  ADD KEY `tag_id` (`tag_id`);

--
-- Indexes for table `content_types`
--
ALTER TABLE `content_types`
  ADD PRIMARY KEY (`content_type_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `specifications`
--
ALTER TABLE `specifications`
  ADD PRIMARY KEY (`specification_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`tag_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `components`
--
ALTER TABLE `components`
  MODIFY `component_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `component_content`
--
ALTER TABLE `component_content`
  MODIFY `content_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=134;

--
-- AUTO_INCREMENT for table `content_types`
--
ALTER TABLE `content_types`
  MODIFY `content_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `specifications`
--
ALTER TABLE `specifications`
  MODIFY `specification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `tags`
--
ALTER TABLE `tags`
  MODIFY `tag_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `category_content_types`
--
ALTER TABLE `category_content_types`
  ADD CONSTRAINT `category_content_types_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `category_content_types_ibfk_2` FOREIGN KEY (`content_type_id`) REFERENCES `content_types` (`content_type_id`);

--
-- Constraints for table `components`
--
ALTER TABLE `components`
  ADD CONSTRAINT `components_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `component_content`
--
ALTER TABLE `component_content`
  ADD CONSTRAINT `component_content_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`component_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `component_content_ibfk_2` FOREIGN KEY (`content_type_id`) REFERENCES `content_types` (`content_type_id`);

--
-- Constraints for table `component_specifications`
--
ALTER TABLE `component_specifications`
  ADD CONSTRAINT `component_specifications_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`component_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `component_specifications_ibfk_2` FOREIGN KEY (`specification_id`) REFERENCES `specifications` (`specification_id`);

--
-- Constraints for table `component_tag`
--
ALTER TABLE `component_tag`
  ADD CONSTRAINT `component_tag_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `components` (`component_id`),
  ADD CONSTRAINT `component_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
